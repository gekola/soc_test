require 'spec_helper'

describe ResultsController do
  render_views
  
  describe "GET 'new'" do
    
    it "should redirect to form path" do
      get :new
      response.should redirect_to(form_path)
    end
  end
  
  describe "POST 'create'" do
    
    describe "testing failures:" do
      
      before(:each) do
	@attr = {:answers => []}
      end
      
      it "should not create a new answer if question doesn't have extra_answer" do
	@questionary = Factory(:questionary)
	@que = Factory(:question, :questionary => @questionary)
	@que.update_attributes(:extra_answer => false)
	@ans1 = Factory(:answer, :question => @que)
	@ans2 = Factory(:answer, :question => @que)
	@attr = {:answers => {"#{@que.id}_extra" => "pishpish"}}
	lambda do
	  post :create, @attr
	end.should_not change(Result,:count)
	lambda do
	  post :create, @attr
	end.should_not change(@que.answers,:count)
      end	
    end
    
    describe "testing success:" do
    
      before(:each) do
	@questionary = Factory(:questionary)
	@que1 = Factory(:question, :questionary => @questionary)
	@ans1 = Factory(:answer, :question => @que1)
	@ans2 = Factory(:answer, :question => @que1)
	@que2 = Factory(:question, :questionary => @questionary)
	@que2.update_attributes(:multians => 3)
	@ans3 = Factory(:answer, :question => @que2)
	@ans4 = Factory(:answer, :question => @que2)
	@que3 = Factory(:question, :questionary => @questionary)
	@ans5 = Factory(:answer, :question => @que3)
	@ans6 = Factory(:answer, :question => @que3)
	@attr = {:answers => {"#{@que1.id}" => "#{@ans2.id}", "#{@ans3.id}_checked" => "1",
	                      "#{@ans4.id}_checked" => "1", "#{@que3.id}" => "new", "#{@que3.id}_extra" => "testextra"}}
      end
    
      it "should redirect to a root path" do
	post :create, @attr
	response.should redirect_to(root_path)
      end
    
      it "should create a new result given valid attr" do
	lambda do
	  post :create, @attr
	end.should change(Result,:count).by(1)
      end
    
      it "should save a valid answers to question with verified=false" do
	lambda do
	  post :create, @attr
	end.should change(@que3.answers,:count).by(1)
      end
    end
  end
end
