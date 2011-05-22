class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end

  def create
    user = User.authenticate(params[:session][:email], params[:session][:password])
    if user.nil?
      # do authentication failed
      flash.now[:error] = "Invalid email/password"
      @title = "Sign in"
      render 'new'
    else
      #do authentication succeeded
      sign_in user
      redirect_to user
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
end
