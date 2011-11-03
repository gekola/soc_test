require 'spec_helper'

describe Questionary do
  
  before(:each) do
    @attr = { :name => "Test questionary",
              :description => "Test description"}
  end
  
  it "should create a new questionary given valid attr" do
    Questionary.create!(@attr)
  end
  
  it "should require a name" do
    Questionary.new(@attr.merge(:name => "")).should_not be_valid
  end
  
  describe "question associations" do
    
    before(:each) do
      @questionary = Questionary.create(@attr)
      @q1 = Factory(:question, :questionary => @questionary )
      @q2 = Factory(:question, :questionary => @questionary )
    end
    
    it "should have a questions attribute" do
      @questionary.should respond_to(:questions)
    end
    
    it "should have the right questions" do
      @questionary.questions.should == [@q1,@q2]
    end
  end
end
