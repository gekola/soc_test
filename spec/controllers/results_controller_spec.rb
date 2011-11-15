require 'spec_helper'

describe ResultsController do
  render_views
  
  describe "GET 'new'" do
    
    it "should be success" do
      @questionary = Factory(:questionary)
      get :new
      response.should be_success
    end
  end
  
  describe "POST 'create'" do
    
    describe "testing failures:" do
      
      before(:each) do
	@attr = {:answers => []}
      end
      
      describe "testing validations" do
	
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
	  @attr = {:answers => {"_#{@que1.id}" => "#{@ans2.id}", "_#{@ans3.id}_checked" => "1",
	                        "_#{@ans4.id}_checked" => "1", "_#{@que2.id}_new_checked" => "1", "_#{@que2.id}_extra" => "testextra2",
	                        "_#{@que3.id}" => "new", "_#{@que3.id}_extra" => "testextra3"}}
	end
	
	it "should stay on new page if creation failed" do
	  @failattr = {:answers => {}}
	  post :create, @failattr
	  response.should render_template(:new)
	end
	
	it "should show an error explanation if creation failed" do
	  lambda do
	    @failattr = {:answers => @attr.merge("_#{@que1.id}" => "#{@ans2.id+100}")}
	    post :create, @failattr
	    response.should have_selector("div#error_explanation", :content => "prohibited this result from being saved:")
	  end
	end
	  
	
	it "should not create a new answer if question doesn't have extra_answer" do
	  lambda do
	    @que = Factory(:question, :questionary => @questionary)
	    @que.update_attributes(:extra_answer => false)
	    @ans1 = Factory(:answer, :question => @que)
	    @ans2 = Factory(:answer, :question => @que)
	    @failattr = {:answers => @attr[:answers].merge("_#{@que.id}_extra" => "pishpish")}
	    lambda do
	      post :create, @failattr
	    end.should_not change(Result,:count)
	    lambda do
	      post :create, @failattr
	    end.should_not change(@que.answers,:count)
	  end
        end
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
	@attr = {:answers => {"_#{@que1.id}" => "#{@ans2.id}", "_#{@ans3.id}_checked" => "1",
	                      "_#{@ans4.id}_checked" => "1", "_#{@que2.id}_new_checked" => "1", "_#{@que2.id}_extra" => "testextra2",
	                      "_#{@que3.id}" => "new", "_#{@que3.id}_extra" => "testextra3"}}
      end
    
      it "should redirect to a thanks page" do
	post :create, @attr
	response.should redirect_to(thanks_path)
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
