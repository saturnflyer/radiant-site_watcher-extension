require File.dirname(__FILE__) + '/../spec_helper'

describe PageRequest do
  before(:each) do
    @page_request = PageRequest.new
  end

  it "should be valid" do
    @page_request.should be_valid
  end
end
