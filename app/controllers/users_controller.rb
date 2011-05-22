class UsersController < ApplicationController
  def new
    @user = User.new
    @title = "Sign Up"
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      # handle a successful save operation 
      flash[:success] = "Welcome to FlickrJuice! #{@user.name}" 
      redirect_to @user
    else
      @title = "Sign Up"
      render 'new'
    end
  end
end

module UsersHelper
  def gravatar_for(user, options = { :size => 50 })
    gravatar_image_tag(user.email.downcase, :alt => user.name, 
                                            :class => 'gravatar',
                                            :gravatar => options)
  end
end
