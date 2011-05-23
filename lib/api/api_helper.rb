require 'ourkudos'
module OurKudos
  module Api
    module Controllers
      module ApiHelper

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
            !c.include?("_at") && !skipped.include?(c)
       end
     end

     def model_as_symbol
       controller_name.singularize.to_sym
     end

     # RESTFUL GENERAL METHODS


        end
      end
   end
end
