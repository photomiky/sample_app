class MicropostsController < ApplicationController
  before_filter :authenticate
  # before performing destroy only function do authorized_user_only
  before_filter :authorized_user_only, :only => :destroy
  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      render 'pages/home'
    end
    
  end

  def destroy
    @micropost.destroy
    redirect_back_or root_path
  end
  
  private 
    def authorized_user_only
      @micropost = Micropost.find(params[:id])
      redirect_to root_path unless current_user  ==@micropost.user 
    end
end