require File.dirname(__FILE__) + '/../spec_helper'

describe SiteController, "with page track" do
  dataset :page_requests, :pages
                                   
  before(:each) do
    controller.stub!(:current_user).and_return(mock_model(User))
    create_page "Oops.", :class_name => 'FileNotFoundPage', :status_id => Status[:published].id
    controller.cache.clear
  end
  
  it "should find or create the requested url in the page_requests" do
    @req_count = PageRequest.count
    get :show_page, :url => '/testing'
    PageRequest.count.should == @req_count + 1
  end
  it "should increment the count_created for the page_request when the cache has expired" do
    get :show_page, :url => "/testing"
    get :show_page, :url => "/testing"
    @recent_request = PageRequest.find_by_url('/testing')
    @recent_request.count_created.should == 2
  end
end