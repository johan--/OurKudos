require 'api_helper'
module OurKudos
  module Api
    module Controllers
      module ServerBase

     include OurKudos::Api::Controllers::ApiHelper


     def index
       resources = current_model.all
       render :json => resources.as_json
     end


     def show
       resource = current_model.find params[:id]
       render :json => resource.as_json
     end

     def update
        resource = current_model.find params[:id]
        if resource.update_attributes cleanup_params(params[model_as_symbol])
          render :json => [:message => respond_with_code(:I2), :code => :I2 ].to_json and return
        else
          render :json => [:message => respond_with_code(:E5), :code => :E5, :errors => resource.errors ].to_json and return
        end
     end

     def create
        resource = current_model.new cleanup_params(params[model_as_symbol])
        if resource.save
          render :json => [:message => respond_with_code(:I1), :code => :I1, params[model_as_symbol] => resource.as_json ].to_json and return
        else
          render :json => [:message => respond_with_code(:E4), :errors => resource.errors, :code => :E4 ].to_json and return
        end
     end

     def destroy
        resource = current_model.find params[:id]
        if resource.save
          render :json => [:message => respond_with_code(:I3), :code => :I3, params[model_as_symbol] => resource.as_json ].to_json and return
        else
          render :json => [:message => respond_with_code(:E10), :errors => resource.errors, :code => :E10 ].to_json and return
        end
     end

     private

      def cleanup_params params
        attributes = current_model.new.attributes.keys.map(&:to_s)
        params.each do |attribute, value|
          params.delete(attribute) unless attributes.include?(attribute)
        end
        params.merge(:user_id => current_user.id)
      end


      end
    end
  end
end