require 'spec_helper'

describe QuestionsController do
  render_views

  describe "GET 'show'" do
    
    before(:each) do
      @questionary = Factory(:questionary)
      @question = Factory(:question, :questionary => @questionary)
    end
    
    it "should be success" do
      get :show, :id => @question
      response.should be_success
    end
    
    it "should find a right question" do
      get :show, :id => @question
      assigns(:question).should == @question
    end
    
    it "should show the rigth answers" do
      a1 = Factory(:answer, :question => @question)
      a2 = Factory(:answer, :question => @question)
      get :show, :id => @question
      response.should have_selector("dd", :content => a1.content)
      response.should have_selector("dd", :content => a2.content)
    end
  end
  
  describe "GET 'new'" do
    
    before(:each) do
      @questionary = Factory(:questionary)
    end
    
    it "should be success" do
      get :new, :questionary_id => @questionary
      response.should be_success
    end
    
    it "should have the right title" do
      get :new, :questionary_id => @questionary
      response.should have_selector(:title, :content => "Creating new question" )
    end
  end
  
  describe "POST 'create'" do
    
    before(:each) do
      @questionary = Factory(:questionary)
    end
    
    describe "testing failures:" do
      
      before (:each) do
	@attr = { :num => "", :content => "" }
      end
      
      it "should not create a questionary with empty attr" do
	lambda do
	  @questionary = Factory(:questionary)
	  post :create, :questionary => {:id => @questionary}, :question => @attr
	end.should_not change(Question, :count)
      end
      
      it "should stay on 'new' page if creating failed" do
	lambda do
	  post :create, :questionary => {:id => @questionary},  :question => @attr
	  response.should render_template(:new)
	end
      end
      
      it "should show an error explanation if creating failed" do
	lambda do
	  post :create, :questionary => {:id => @questionary},  :question => @attr
	  response.should have_selector("div#error_explanation", :content => "prohibited this questionary form being saved:")
	end
      end
    end
    
    describe "testing success:" do
      
      before(:each) do
	@attr = { :num => 1, :content => "Test question?" }
      end
      
      it "should create a valid question" do
	lambda do
	  post :create, :questionary => {:id => @questionary},  :question => @attr
	end.should change(Question, :count).by(1)
      end
      
      it "should redirect to the question show page" do
	lambda do
	  post :create, :questionary => {:id => @questionary},  :question => @attr
	  response.should redirect_to(question_path(assigns(:question)))
	end
      end	
    end  
  end  
end
