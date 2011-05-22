require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :name => "Example User", :email => "user@example.com", :password => "password", :password_confirmation => "password"}
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end
  
  it "should require an email" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  it "should reject long user names" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  
  it "should reject invalid emails" do
    addresses = %w[user@foo,com user_at_foo.org,example.user@foo.]
    addresses.each do | address |
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should require unique emails" do
    User.create!(@attr)
    user_with_dup_email = User.new(@attr)
    user_with_dup_email.should_not be_valid
  end
  
  it "should reject duplicate emails regardless of case" do
    uppercase_email = @attr[:email].upcase 
    User.create!(@attr.merge(:email => uppercase_email))
    user_with_dup_email = User.new(@attr)
    user_with_dup_email.should_not be_valid
  end
    
  describe "password_validations" do
    
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end
    
    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
    end
    
    it "should reject short passwords" do 
      short_password = 'a'* 4
      hash = @attr.merge(:password => short_password, :password_confirmation => short_password)
      User.new(hash).should_not be_valid
    end
      
    it "should reject long passwords" do
      long = 'a' * 60
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
    
  end 
  
  describe "encrypted_password" do
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should should have an encrypted password" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end
  end

  describe "has_password? method" do
      before(:each) do
        @user = User.create!(@attr)
      end
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end    

      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end 
  end
  
  describe "authenticate method" do
    
    it "should return nil if email/password mismatch" do
      wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
      wrong_password_user.should be_nil
    end
    
    it "should return nil if email is not in system" do
      nonexistant_user = User.authenticate("bar@foo.com", @attr[:password])
      nonexistant_user.should be_nil
    end
    
    it "should return valid user if password matches one stored" do
      good_user = User.authenticate(@attr[:name], @attr[:password])
      good_user.should == @user
    end
  end
  
  
end