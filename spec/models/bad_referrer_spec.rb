require File.dirname(__FILE__) + '/../spec_helper'

describe BadReferrer do
  before(:each) do
    @bad_referrer = BadReferrer.new
  end

  it "should be valid" do
    @bad_referrer.should be_valid
  end
end
