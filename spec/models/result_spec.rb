require 'spec_helper'

describe Result do
  
  before(:each) do
    @questionary = Factory(:questionary)
    @attr = { :information => {1 => 1} }
  end

  it "should create a new instance given valid attr" do
    Result.create!(@attr)
  end
  
  describe "questionary associations" do
    
    before(:each) do
      @result = Result.create(@attr)
    end
    
    it "should have an questionary attr" do
      @result.should respond_to(:questionary)
    end
    
    it "should have the right assocciated questionary"
  end

  describe "validations" do
    
    it "should require a information attr" do
      Result.new(@attr.merge(:information => nil)).should_not be_valid
    end

    it "should require a questionary id" do
      Result.new(@attr.merge(:questionary_id => nil)).should_not be_valid
    end
  end
end
