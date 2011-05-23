module OurKudos
  module Api
    module DateTimeFormatter
    
    def datetime_fields
      @datetime_fields ||= attributes.select { |k,v| k.include?("_at") && v.to_s.include?(":") }.keys
    end

    def formatted_datetime_fields
      datetime_fields.map {|field| "formatted_#{field}" }
    end

    def as_json(args={})
      build_methods
      super(:methods => formatted_datetime_fields, :except=> datetime_fields)
    end


    def build_methods
       datetime_fields.each do |attribute|
        class_eval do
          define_method "formatted_#{attribute}" do
              self.send(attribute).strftime("%d-%m-%Y %H-%M")
          end
        end
      end
    end


  end
 end
end


