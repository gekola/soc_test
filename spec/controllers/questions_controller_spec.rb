require 'spec_helper'

describe QuestionsController do
  render_views

  before(:each) do
    session[:authorized] = true
    session[:ip] = request.remote_ip
  end

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

      it "should not create a question with empty attr" do
	lambda do
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
	  response.should have_selector("div#error_explanation", :content => "prohibited this question form being saved:")
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

  describe "GET 'edit'" do

    before(:each) do
      @question = Factory(:question)
    end

    it "should be successful" do
      get :edit, :id => @question
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @question
      response.should have_selector("title", :content => "Edit question")
    end
  end

  describe "PUT 'update'" do

    before(:each) do
      @question = Factory(:question)
    end

    describe "testing failure:" do

      before (:each) do
	@attr = { :num => "", :content => "" }
      end

      it "should stay on 'edit' page if creating failed" do
	lambda do
	  post :update, :id => @question, :question => @attr
	  response.should render_template(:edit)
	end
      end

      it "should show an error explanation if edit failed" do
	lambda do
	  post :update, :id => @question, :question => @attr
	  response.should have_selector("div#error_explanation", :content => "prohibited this question
	                                form being saved:")
	end
      end
    end

    describe "testing success:" do

      before(:each) do
	@attr = { :num => 20, :content => "Ch test question?" }
      end

      it "should change a question attributes" do
	lambda do
	  post :update, :id => @question, :question => @attr
	  @question.reload
	  @question.num.should == @attr[:num]
	  @question.content.should == @attr[:content]
	end
      end

      it "should redirect to the question show page" do
	lambda do
	  post :update, :id => @question, :question => @attr
	  response.should redirect_to(question_path(@question))
	end
      end
    end
  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @questionary = Factory(:questionary)
      @question = Factory(:question, :questionary => @questionary)
    end

    it "should destroy the question" do
      lambda do
        delete :destroy, :id => @question
      end.should change(Question, :count).by(-1)
    end

    it "should redirect to the questionary show page" do
      delete :destroy, :id => @question
      response.should redirect_to(@questionary)
    end
  end

  describe "answers associations" do

    before (:each) do
      @question = Factory(:question)
      @a1 = Factory(:answer, :question => @question)
      @a2 = Factory(:answer, :question => @question)
    end

    it "should have a answers attribute" do
      @question.should respond_to(:answers)
    end

    it "should have the right answer" do
      @question.answers.should == [@a1, @a2]
    end

    it "should destroy associated questions" do
      @question.destroy
      [@a1, @a2].each do |answer|
        Answer.find_by_id(answer).should be_nil
      end
    end
  end
end
