require File.dirname(__FILE__) + '/../spec_helper'

describe "PopularPageTags" do
  scenario :pages, :page_requests
  
  before(:each) do
    @page_request = mock_model(PageRequest)
    @page_request.stub!(:url).and_return("/parent/child")
    @page_request.stub!(:virtual).and_return(false)
    @page_request.stub!(:count_created).and_return(5)
  end

  describe "<r:popular>" do
    it "should expand it's contents" do
      pages(:child).should render('<r:popular>true</r:popular>').as('true')
    end
  end
  describe "<r:popular:pages>" do
    it "should expand it's contents" do
      pages(:child).should render('<r:popular:pages>true</r:popular:pages>').as('true')
    end
  end
  describe "<r:popular:pages:each>" do
    it "should display it's contents for each popular page" do
      pages(:child).should render('<r:popular:pages:each>true </r:popular:pages:each>').as('true true true true true true true true true true ')
    end
    it "should set the current page to the popular page in the iteration" do
      pages(:home).should render('<r:popular:pages:each><r:title /> </r:popular:pages:each>').as('Eris Pluto Neptune Uranus Saturn Jupiter Mars Earth Venus Mercury ')
    end
    it "should limit the group of popular pages to the given 'limit' attribute" do
      pages(:home).should render('<r:popular:pages:each limit="3"><r:title /> </r:popular:pages:each>').as('Eris Pluto Neptune ')
    end
    it "should limit the group of popular pages to pages by the given 'author' attribute for the user with the matching 'login'" do
      pages(:home).should render('<r:popular:pages:each author="existing"><r:title /> </r:popular:pages:each>').as('Eris Venus Mercury ')
    end
  end
end
