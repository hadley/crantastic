require File.dirname(__FILE__) + '/../spec_helper'

describe Tagging do
  it "should only accept valid tag names" do
    Tagging.new(:tag => "").should have(2).errors_on(:tag)
    Tagging.new(:tag => " dd").should have(1).errors_on(:tag)
    Tagging.new(:tag => "MachineLearning").should have(0).errors_on(:tag)
  end
end
