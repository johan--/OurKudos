module OurKudos
  module Acts
    module Resource

     def self.included(base)
       base.extend AddActsAsOurKudosResource
     end
     
     module AddActsAsOurKudosResource

          def ourkudos_resource(options = {})
             attr_reader :ourkudos_response
          
             belongs_to :user

             validates_with RemoteResourceValidator

              class_eval <<-RUBY
               include OurKudos::Acts::Resource::InstanceMethods
               extend  OurKudos::Acts::Resource::InstanceMethods::ClassMethods
              RUBY

          end
     end

     
     module InstanceMethods

      def id
        self.remote_uid
      end

      def internal_id
        self.attributes["id"]
      end

      def do_request method = :post
        @ourkudos_response ||=
          clean_up_response ActiveSupport::JSON.decode(user.ourkudos.send method, controller_api_path(method), {model_symbol => self.attributes}.merge(:oauth_token => user.authentication_token))
      end

      def has_any_errors?
        ourkudos_response["code"].include? "E"
      end

      def model_symbol
        self.class.model_name.singular.to_sym
      end

      def after_request_processing
        set_errors_if_any
        set_remote_id_if_exists
      end

      def set_errors_if_any
        ourkudos_response["errors"].each {|k,v| errors[k] = v} if has_any_errors?
      end

      def set_remote_id_if_exists
        self.remote_uid = ourkudos_response.recursive_find_by_key("id") if response_includes_self?
      end

      def destroy_remotely
        do_request :delete
        !ourkudos_response.recursive_find_by_key("code").blank? &&
             ourkudos_response["code"] == "I3"  &&
                destroy
      end

      def controller_api_path method = :post
        return "/api/users/#{user.id}/#{plural_name}"            if method == :post
        return "/api/users/#{user.id}/#{plural_name}/#{id.to_s}" if method == :put || method == :delete
      end

      def response_includes_self?
        !ourkudos_response.recursive_find_by_key(singular_name).blank?
      end

      def plural_name
        ActiveModel::Naming.plural self
      end

      def singular_name
        ActiveModel::Naming.singular self
      end

      def clean_up_response response
        response.is_a?(Hash) ? (return response) : (return response.first)
      end
     
     module ClassMethods

        def controller_get_path user, remote_id
          "/api/users/#{user.id}/#{ActiveModel::Naming.plural self}/#{remote_id.to_s}"
        end

        def find_remotely user, remote_id
          resource = ActiveSupport::JSON.decode user.ourkudos.get controller_get_path(user, remote_id) rescue raise ActiveRecord::RecordNotFound
          if resource && resource[singular_name]
            local_resource = find_by_remote_uid(remote_id)
           return local_resource if resource[singular_name]["id"] == local_resource.id
          end
          raise ActiveRecord::RecordNotFound
       end

        def plural_name
          ActiveModel::Naming.plural self
        end

        def singular_name
          ActiveModel::Naming.singular self
        end

     end

     end

   end
  end
end