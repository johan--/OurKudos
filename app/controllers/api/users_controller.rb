class Api::UsersController < ApiBaseController

  respond_to :json
  
  def create
    @user = User.new params[:user]
    respond_with @user, :location => api_users_url do
      if @user.save
        render :json => [:message => respond_with_code(:I1), :code => :I1, :user => @user.as_json ].to_json and return
      else
        render :json => [:message => respond_with_code(:E4), :errors => @user.errors, :code => :E4 ].to_json and return
      end
    end
  end
  
  def index
    @users = User.all
    respond_with @users, :location => api_users_url
  end
  
  def show
    show_action
  end
  
  def update
    @user = User.find params[:id]
    if @user.update_attributes params[:user]
       render :json => [:message => respond_with_code(:I2), :code => :I2 ].to_json and return
    else
       render :json => [:message => respond_with_code(:E5), :code => :E5, :errors => @user.errors ].to_json and return
    end  
  end
    
    
  
end
