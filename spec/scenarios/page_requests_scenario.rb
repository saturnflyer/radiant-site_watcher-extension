class PageRequestsScenario < Scenario::Base
  class VirtualPage < Page
    def virtual?
      true
    end
  end
  
  uses :home_page, :users
  
  def load
    create_page "Mercury", :created_by_id => users(:existing).id
    create_page "Venus", :created_by_id => users(:existing).id
    create_page "Earth", :body => "<r:title />"
    create_page "Mars" do
      create_page "Jupiter" do
        create_page "Saturn" do
          create_page "Uranus"
        end
      end
      create_page "Neptune"
      create_page "Pluto"
    end
    create_page "Eris", :created_by_id => users(:existing).id
    
    create_page_request "first",    "mercury",  1, true
    create_page_request "second",   "venus",  2
    create_page_request "third",    "earth",  3
    create_page_request "fourth",   "mars",  4
    create_page_request "fifth",    "mars/jupiter",  5
    create_page_request "sixth",    "mars/jupiter/saturn",  6
    create_page_request "seventh",  "mars/jupiter/saturn/uranus",  7
    create_page_request "eighth",   "mars/neptune",  8
    create_page_request "ninth",    "mars/pluto",  9
    create_page_request "tenth",    "eris",  10
  end
  
  def create_page_request(name, url, count_created, ignore=false)
    create_record :page_request, name.symbolize, :url => "#{url}", :count_created => count_created, :ignore => ignore
  end
  
end