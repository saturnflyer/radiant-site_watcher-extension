class NotFoundRequestsDataset < Dataset::Base
  class VirtualPage < Page
    def virtual?
      true
    end
  end
  
  uses :home_page, :users
  
  def load
    create_not_found_request 'not1', 'no-way/on-earth/this-page-exists'
  end
  
  def create_not_found_request(name, url, count_created=0)
    create_record :not_found_request, name.symbolize, :url => "#{url}", :count_created => count_created
  end
  
end