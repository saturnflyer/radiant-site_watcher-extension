# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class SiteWatcherExtension < Radiant::Extension
  version "1.0"
  description "Records a count of the number of times each page's cache is created."
  url "http://saturnflyer.com/"
  
  def activate
    SiteController.send :include, SiteWatcher::PageTrack
    Page.class_eval do
      include PopularPageTags
      def self.find_popular
        count_max = PageRequest.maximum(:count_created)
        count_limit = count_max / 4
        count_bottom = count_max - count_limit
        page_requests = PageRequest.find(:all, :order => 'count_created DESC', :limit => 25)
        pages = []
        page_requests.each do |req|
          pages << Page.find_by_url(req.url)
        end
        pages
      end
    end
  end
  
  def deactivate
    # admin.tabs.remove "Site Watcher"
  end
  
end