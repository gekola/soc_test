require 'spec_helper'

describe AnswersController do
  render_views

  describe "GET 'new'" do
    
    before(:each) do
      @question = Factory(:question)
    end
    
    it "should be success" do
      get :new, :question_id => @question
      response.should be_success
    end
    
    it "should have the right title" do
      get :new, :question_id => @question
      response.should have_selector(:title, :content => "Creating new answer" )
    end
  end
  
  describe "POST 'create'" do
    
    before(:each) do
      @question = Factory(:question)
    end
    
    describe "testing failures:" do
      
      before (:each) do
	@attr = { :num => "", :content => "" }
      end
      
      it "should not create a answer with empty attr" do
	lambda do
	  post :create, :question => {:id => @question}, :answer => @attr
	end.should_not change(Answer, :count)
      end
      
      it "should stay on 'new' page if creating failed" do
	lambda do
	  post :create, :question => {:id => @question},  :answer => @attr
	  response.should render_template(:new)
	end
      end
      
      it "should show an error explanation if creating failed" do
	lambda do
	  post :create, :question => {:id => @question},  :answer => @attr
	  response.should have_selector("div#error_explanation", :content => "prohibited this answer form being saved:")
	end
      end
    end
    
    describe "testing success:" do
      
      before(:each) do
	@attr = { :num => 1, :content => "Test answer" }
      end
      
      it "should create a valid answer" do
	lambda do
	  post :create, :question => {:id => @question},  :answer => @attr
	end.should change(Answer, :count).by(1)
      end
      
      it "should redirect back to the question show page" do
	lambda do
	  post :create, :question => {:id => @question},  :answer => @attr
	  response.should redirect_to(question_path(assigns(:question)))
	end
      end	
    end  
  end
end
