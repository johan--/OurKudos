require 'ourkudos'
module OurKudos
  module Controllers
    module ApiHelper

    # this is called before every API action, user is authenticatied - yield - calls the contro.ller action, and log outs user 
      def authenticate_and_logout
        
          current_api = ApiKey.find_by_key params[:api_key]

          return authorization_response(1) if current_api.blank? #no user with such api key
          return authorization_response(2) if current_api.expired? #api key invalid/expired
          return authorization_response(3) if current_api.site.blocked?  #api key valid, but the site was blocked, stop action

          yield #here is the controller action

          current_api = nil #log out user
        
      end

      def authorization_response response_code
         render :json => [:message => OurKudos::ResponseCodes["E#{response_code.to_s}".to_sym],
                          :code   => ":E#{response_code.to_s}".to_sym ].to_json
         false
      end

      def respond_with_code code_number
        OurKudos::ResponseCodes[code_number.to_sym]
      end

      def current_model
        @current_model ||= Kernel.const_get controller_name.singularize.classify
      end

      # same as above but already as json
      def respond_with_json_code code_number
        render :json => [:message => OurKudos::ResponseCodes[code_number.to_sym], :code => code_number.to_sym ]
      end

      def no_record
        respond_with_json_code :E8
      end

      def no_resource
        respond_with_json_code :E9
      end

     def api_columns *skipped
        current_model.column_names.select do |c|
          !c.include?("_id") && !c.include?("_by") &&
            !c.include?("_at") && c != "id" && !skipped.include?(c)
       end
     end

     def model_as_symbol
       controller_name.singularize.to_sym
     end

     def authenticate!
        authenticate_or_request_with_http_basic do |email, password|
          email == params[:email] && password == params[:password]
        end
     end

     # RESTFUL GENERAL METHODS

     def show
       resource = current_model.find params[:id]       
       render :json => resource.as_json 
     end

     def update
        resource = current_model.find params[:id]
        if resource.update_attributes params[model_as_symbol]
          render :json => [:message => respond_with_code(:I2), :code => :I2 ].to_json and return
        else
          render :json => [:message => respond_with_code(:E5), :code => :E5, :errors => resource.errors ].to_json and return
        end
     end

     def create
        resource = current_model.new params[model_as_symbol]
        if resource.save
          render :json => [:message => respond_with_code(:I1), :code => :I1, :user => resource.as_json ].to_json and return
        else
          render :json => [:message => respond_with_code(:E4), :errors => resource.errors, :code => :E4 ].to_json and return
        end
     end

     def destroy
        resource = current_model.find params[:id]
        if resource.save
          render :json => [:message => respond_with_code(:I3), :code => :I3, :user => resource.as_json ].to_json and return
        else
          render :json => [:message => respond_with_code(:E10), :errors => resource.errors, :code => :E10 ].to_json and return
        end
     end




    end
  end
end
