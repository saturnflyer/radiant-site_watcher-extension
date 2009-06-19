require File.dirname(__FILE__) + '/../spec_helper'

describe NotFoundRequest do
  dataset :not_found_requests
  before(:each) do
    @not_found_request = NotFoundRequest.create!(:url => 'no-where-to-be-found')
    @not_found_request2 = NotFoundRequest.new(:url => 'no-where-to-be-found')
  end

  it "should be valid" do
    @not_found_request.should be_valid
  end
  
  it "should set the count_created to 1 when creating" do
    @not_found_request.count_created.should == 1
  end
  
  it "should increment the count_created on an existing NotFoundRequest" do
    @not_found_request.save
    @not_found_request.count_created.should == 2
  end
  
  it "should err with 'has already been taken' when asked to save a non-unique url" do
    @not_found_request2.valid?
    @not_found_request2.errors.on(:url).should match(/has already been taken/)
  end
end
