require 'spec_helper'

describe Result do

  before(:each) do
    @questionary = Factory(:questionary)
    @question = Factory(:question, :questionary => @questionary)
    @answer = Factory(:answer, :question => @question)
    @attr = { :information => [@answer.id] }
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
      @questionary.results.new(@attr.merge(:information => [2])).should_not be_valid
    end

    it "shoult require a question (for which answer is) to be belong to the same questionary as the result" do
      questionary2 = Factory(:questionary)
      question2 = Factory(:question, :questionary => questionary2)
      answer2 = Factory(:answer, :question => question2)
      @questionary.results.new(:information => [answer2.id]).should_not be_valid
    end

    it "shoult require a valid new answer" do
      result = @questionary.results.create!(@attr)
      result2 = @questionary.results.create!(@attr)
      new_answer = Factory(:answer, :question => @question, :result => result2)
      new_answer.verified = false
      new_answer.save!
      result.update_attributes(:information => [new_answer.id]).should be_false
    end
  end
end
