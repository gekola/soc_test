require 'spec_helper'

describe Result do

  before(:each) do
    @questionary = Factory(:questionary)
    @question = Factory(:question, :questionary => @questionary)
    @question.num = 1
    @question.save
    @answer = Factory(:answer, :question => @question)
    @answer.num = 1
    @answer.save
    @attr = { :information => {1 => [1]} }
  end

  it "should create a new instance given valid attr" do
    @questionary.results.create!(@attr)
  end

  describe "questionary associations" do

    before(:each) do
      @result = @questionary.results.create(@attr)
    end

    it "should have an questionary attr" do
      @result.should respond_to(:questionary)
    end

    it "should have the right assocciated questionary" do
      @result.questionary_id.should == @questionary.id
      @result.questionary.should == @questionary
    end
  end
  
  describe "validations" do
    
    it "should require a information attr" do
      @questionary.results.new(@attr.merge(:information => nil)).should_not be_valid
    end
    
    it "should require a questionary id" do
      Result.new(@attr).should_not be_valid
    end

    it "should require a valid information attr" do
      @questionary.results.new(@attr.merge(:information => {1=>[2]})).should_not be_valid
    end
  end
end
