require 'spec_helper'

describe QuestionariesController do
  render_views

  describe "GET 'index'" do
    before(:each) do
      @questionaries = []
      5.times do
        @questionaries << Factory(:questionary)
      end
    end

    it "should be successful" do
      get :index
      response.should be_success
    end

    it "should have the right title" do
      get :index
      response.should have_selector("title", :content => "All questionaries")
    end

    it "should have an element for each questionary" do
        get :index
        @questionaries.each do |questionary|
          response.should have_selector("td", :content => questionary.name)
        end
      end
  end

  describe "GET 'show'" do

    before(:each) do
      @questionary = Factory(:questionary)
    end

    it "should be successful" do
      get :show, :id => @questionary
      response.should be_success
    end

    it "should find the right questionary" do
      get :show, :id => @questionary
      assigns(:questionary).should == @questionary
    end

    it "should have the right title" do
      get :show, :id => @questionary
      response.should have_selector("title", :content => @questionary.name)
    end

    it "should show the questionary's questions" do
      q1 = Factory(:question, :questionary => @questionary)
      q2 = Factory(:question, :questionary => @questionary)
      get :show, :id => @questionary
      response.should have_selector("span.content", :content => q1.content)
      response.should have_selector("span.content", :content => q2.content)
    end
  end
  
  describe "GET 'new'" do
    
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Creating new questionary")
    end    
  end
  
  describe "POST 'create'" do
    
    describe "testing failures:" do
      
      before (:each) do
	@attr = { :name => "", :description => "" }
      end
      
      it "should not create a questionary with empty attr" do
	lambda do
	  post :create, :questionary => @attr
	end.should_not change(Questionary, :count)
      end
      
      it "should stay on 'new' page if creating failed" do
	lambda do
	  post :create, :questionary => @attr
	  response.should render_template(:new)
	end
      end
      
      it "should show an error explanation if creating failed" do
	lambda do
	  post :create, :questionary => @attr
	  response.should have_selector("div#error_explanation", :content => "prohibited this questionary
	                                form being saved:")
	end
      end
    end
    
    describe "testing success:" do
      
      before(:each) do
	@attr = { :name => "TestQuestionary", :description => "Description of test questionary" }
      end
      
      it "should create a valid questionary" do
	lambda do
	  post :create, :questionary => @attr
	end.should change(Questionary, :count).by(1)
      end
      
      # next test may be changed, maybe it should redirect to other page
      it "should redirect to the questionary show page" do
	lambda do
	  post :create, :questionary => @attr
	  response.should redirect_to(questionary_path(assigns(:questionary)))
	end
      end	
    end  
  end

  describe "questions associations" do

    before (:each) do
      @questionary = Factory(:questionary)
      @q1 = Factory(:question, :questionary => @questionary)
      @q2 = Factory(:question, :questionary => @questionary)
    end

    it "should have a questions attribute" do
      @questionary.should respond_to(:questions)
    end

    it "should have the right questions" do
      @questionary.questions.should == [@q1, @q2]
    end

    it "should destroy associated questions" do
      @questionary.destroy
      [@q1, @q2].each do |question|
        Question.find_by_id(question.id).should be_nil
      end
    end
  end
end
