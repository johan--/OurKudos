require 'ourkudos'
module OurKudos
  module Api
    module Controllers
      module ApiHelper

        def current_model
          @current_model ||= Kernel.const_get controller_name.singularize.classify
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

        def model_instance
          @model_insstance ||= instance_variable_get "@#{controller_name.singularize}"
        end


        def respond_with_code code_number
          OurKudos::ResponseCodes[code_number.to_sym]
        end

        end
      end
   end
end
