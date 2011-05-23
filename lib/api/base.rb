require 'api_helper'
module OurKudos
  module Api
    module Controllers
      module ServerBase

     include OurKudos::Api::Controllers::ApiHelper

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
end