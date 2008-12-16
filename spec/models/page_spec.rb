require File.dirname(__FILE__) + '/../spec_helper'

describe Page do
  scenario :users, :pages, :page_requests
  
  it "should update the page_request virtual field when the page with the same url is created" do
    PageRequest.create(:url => 'created_before_page', :virtual => true)
    @page = Page.create(:title => 'New page', :slug => 'created_before_page', :breadcrumb => 'new-page')
    @page_request = PageRequest.find_by_url(@page.url)
    @page_request.virtual.should_not be_true
  end
  
  describe "find_popular" do
    it "should find pages by a given author using the author login name" do
      Page.find_popular(25,'existing').should == [pages(:eris), pages(:venus), pages(:mercury)]
    end 
  end
end