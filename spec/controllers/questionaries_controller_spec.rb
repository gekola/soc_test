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
