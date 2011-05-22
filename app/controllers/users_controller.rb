class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update, :index]
  before_filter :correct_user, :only => [:edit, :update]
 
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
      sign_in @user
      flash[:success] = "Welcome to FlickrJuice! #{@user.name}" 
      redirect_to @user
    else
      @title = "Sign Up"
      render 'new'
    end
  end
  
  def edit
    @title = "Edit user"
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def index
    @title = "All users"
    @users = User.all
  end
  
  private 
     def authenticate
       deny_access unless signed_in?
     end
     
     def correct_user 
       @user = User.find(params[:id])
       redirect_to(root_path) unless correct_user?(@user)
     end
     
  
end
