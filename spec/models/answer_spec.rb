require 'spec_helper'

describe Answer do

  before(:each) do
    @question = Factory(:question)
    @attr = { :num => 1, :content => "test answer", :verified => true }
  end

  it "should create a new instance given valid attr" do
    @question.answers.create!(@attr)
  end

  describe "question associations" do

    before(:each) do
      @answer = @question.answers.create(@attr)
    end

    it "should have an question attr" do
      @answer.should respond_to(:question)
    end

    it "should have the right assocciated question" do
      @answer.question_id.should == @question.id
      @answer.question.should == @question
    end
  end

  describe "validations" do
    
    it "should require a num attr" do
      @question.answers.build(@attr.merge(:num => nil)).should_not be_valid
    end
      
    it "should require a question id" do
      Answer.new(@attr).should_not be_valid
    end
    
    it "should require nonblank content" do
      @question.answers.build(@attr.merge(:content => "      ")).should_not be_valid
    end
    
    it "should reject long content" do
      @question.answers.build(@attr.merge(:content => "a"*141)).should_not be_valid
    end

    it "should reject answers with same numbers within a question" do
      @question.answers.create(@attr)
      @question.answers.build(@attr).should_not be_valid
    end

    it "should require a result_id if it's not verified" do
      @question.answers.build(@attr.merge(:verified => false)).should_not be_valid
#      @question.answers.build(@attr.merge(:verified => false, :result_id => 1)).should respond_to(:result_id)
    end
  end
end
