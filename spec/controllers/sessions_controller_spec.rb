require 'spec_helper'

describe SessionsController do
  
  render_views
  
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Sign in")
    end 
    
  end

  describe "POST 'create'" do
    describe "invalid login" do
      
      before(:each) do
        @attr = { :email => "photomiky@gmail.com", :password => "invalid"}
      end
      
      it "should rerender the new page" do
        post :create, :session => @attr
        response.should render_template('new')
      end
      
      it "should have the right title" do
        post :create, :session => @attr
        response.should have_selector("title", :content => "Sign in")
      end
      
      it "should have a flash.now message" do
        post :create, :session => @attr
        flash.now[:error].should =~ /invalid/i
      end
    end
    
    describe "with valid email and password" do
      
      before(:each) do
        @user = Factory(:user)
        @attr = {:email => @user.email, :password => @user.password}
      end
      
      it "should sign the user in" do
        post :create, :session => @attr
        # test the signed in user
        controller.current_user.should == @user
        controller.should be_signed_in
      end
      
      it "should redirect to user" do
        post :create, :session => @attr
        response.should redirect_to(user_path(@user))
      end
      
    end
    
  end

  describe "DELETE 'destroy'" do
    
    it "should sign user out" do
      test_sign_in(Factory(:user))
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end
    
  end

end