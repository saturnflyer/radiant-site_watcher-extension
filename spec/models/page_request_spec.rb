require File.dirname(__FILE__) + '/../spec_helper'

describe PageRequest do
  before(:each) do
    @page_request = PageRequest.create!(:url => 'this/and/that')
    @page_request2 = PageRequest.new(:url => 'this/and/that')
  end

  it "should record the url '/' as '/'" do
    @page_request.update_attribute(:url,'/')
    @page_request.url.should == '/'
  end
  
  it "should record a url without a leading slash as one with a leading slash" do
    @page_request.url.should == '/this/and/that'
  end
  
  it "should set the count_created to 1 when creating" do
    @page_request.count_created.should == 1
  end
  
  it "should increment the count_created on an existing PageRequest" do
    @page_request.save
    @page_request.count_created.should == 2
  end
  
  it "should err with 'has already been taken' when asked to save a non-unique url" do
    @page_request2.valid?
    @page_request2.errors.on(:url).should match(/has already been taken/)
  end
  
  it "should return it's popularity as the count_created divided by the maximum value of all count_created multiplied by 100" do
    @page_request2.url = "other"
    @page_request2.count_created = 13
    @page_request2.save
    @page_request.update_attribute(:count_created, 10)
    @page_request.popularity.should == '79'
  end
  
  it "should be able to reset all count_created to 1" do
    PageRequest.reset_counts
    @page_request.count_created.should == 1
  end
end
