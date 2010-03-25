require File.dirname(__FILE__) + '/../spec_helper'

describe BadDirection do
  before(:each) do
    @bad_direction = BadDirection.new
  end

  it "should be valid" do
    @bad_direction.should be_valid
  end
end
