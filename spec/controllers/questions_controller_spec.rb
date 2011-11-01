require 'spec_helper'

describe QuestionsController do
  render_views

  describe "GET 'show'" do
    
    before(:each) do
      @questionary = Factory(:questionary)
      @question = Factory(:question, :questionary => @questionary)
    end
    
    it "show should be success" do
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
end
