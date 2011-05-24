require 'spec_helper'

describe MicropostsController do
  render_views

  describe "access control" do

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end
  
  describe "POST 'create'" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
      end
      
      describe "fail" do
        before(:each) do
          @attr = { :content => ""}
        end
        
        it "should not be successfull" do
          lambda do
            post :create, :micropost => @attr
          end.should_not change(Micropost, :count)
        end
        
        it "should display the homepage" do
          post :create, :micropost => @attr
          response.should render_template('pages/home')
        end
      end
      
      describe "success" do
        
        before(:each) do
          @attr = { :content => "bla bla bla"}
        end
         
        it "should be successfull" do
          lamda do
            post :create, :micropost => @attr
          end.should change(Micropost, :count).by(1)
        end
        
        it "should redirect to home page" do
          post :create, :micropost => @attr
          response.should redirect_to(root_path)
        end
        
        it "should have a flash message" do
          post :create, :micropost => @attr
          flash[:success].should ~= /micropost created/i
        end
        
      end
  end
end