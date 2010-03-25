require File.dirname(__FILE__) + '/../spec_helper'

describe SiteController, "with page track" do
  dataset :page_requests, :pages
                                   
  before(:each) do
    controller.stub!(:current_user).and_return(mock_model(User))
    create_page "Oops.", :class_name => 'FileNotFoundPage', :status_id => Status[:published].id
    @cache = Radiant::Cache
    @cache.clear
  end
  
  it "should find or create the requested url in the page_requests" do
    # PageRequest.delete_all
    @req_count = PageRequest.count
    @cache.clear
    get :show_page, :url => '/testing'
    PageRequest.count.should == @req_count + 1
  end
  it "should increment the count_created for the page_request when the cache has expired" do
    PageRequest.delete_all
    get :show_page, :url => "/testing"
    @cache.clear
    get :show_page, :url => "/testing"
    @recent_request = PageRequest.find_by_url('/testing')
    @recent_request.count_created.should == 2
  end
  describe "for 404 content" do
    before do
      request.env['HTTP_REFERER'] = 'http://dumbsite.net'
    end
    it "should create a bad_referrer if the content is not accessed directly" do
      get :show_page, :url => '/bad_url'
      @bad_referrer = BadReferrer.find_by_url('http://dumbsite.net')
      @bad_referrer.url.should == 'http://dumbsite.net'
    end
    it "should create a not_found_request" do
      get :show_page, :url => '/bad_url'
      @bad_referrer = NotFoundRequest.find_by_url('/bad_url')
      @bad_referrer.url.should == '/bad_url'
    end
  end
end