require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::PageRequestsController do
  dataset :users, :page_requests
  
  describe "when receiving a DELETE request to /admin/page_request/:id" do
    before(:each) do
      login_as :admin
      @id = page_requests(:first).id
      request.env["HTTP_REFERER"] = "http://test.host/admin/dashboard"
      delete :destroy, :id => @id
    end
    
    it "should delete a page request record" do
      lambda {PageRequest.find(@id)}.should raise_error(ActiveRecord::RecordNotFound)
    end
    it "should redirect back to the originating page" do
      response.should redirect_to(:back)
    end
    it "should display the message 'The page request mercury has been deleted. It had been requested 1 times.'" do
      flash[:message].should == 'The page request mercury has been deleted. It had been requested 1 times.'
    end
  end
  
  describe "when receiving a PUT request to /admin/page_request/:id/ignore" do
    before(:each) do
      login_as :admin
      @id = page_requests(:first).id
      request.env["HTTP_REFERER"] = "http://test.host/admin/dashboard"
      put :ignore, :id => @id
    end
    it "should set the ignore attribute to true" do
      page_requests(:first).ignore.should be_true
    end
    it "should redirect back to the originating page" do
      response.should redirect_to(:back)
    end
  end
end