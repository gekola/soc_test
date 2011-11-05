require 'spec_helper'

describe Question do

  before (:each) do
    @questionary = Factory(:questionary)
    @attr = {:num => 1, :content => "test question?", :extra_answer => true, :multians => 1}
  end

  it "should create a new instance given valid attr" do
    @questionary.questions.create!(@attr)
  end
  
  describe "questionary associations" do
    
    before (:each) do
      @question = @questionary.questions.create(@attr)
    end
    
    it "should have an questionary attr" do
      @question.should respond_to(:questionary)
    end
    
    it "should have the right associated questionary" do
      @question.questionary_id.should == @questionary.id
      @question.questionary.should == @questionary
    end
  end
  
  describe "validations" do
    
    it "should require a num attr" do
      @questionary.questions.build(@attr.merge(:num => nil)).should_not be_valid
    end

    it "should require a questionary id" do
      Question.new(@attr).should_not be_valid
    end
    
    it "should require nonblank content" do
      @questionary.questions.build(@attr.merge(:content => "      ")).should_not be_valid
    end
    
    it "should reject long content" do
      @questionary.questions.build(@attr.merge(:content => "a"*141)).should_not be_valid
    end
    
    it "should reject questions with same numbers within a questionary" do
      @questionary.questions.create(@attr)
      @questionary.questions.build(@attr).should_not be_valid
    end
  end
end
