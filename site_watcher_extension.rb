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
      def self.find_popular(num=25)
        page_requests = PageRequest.find(:all, :order => 'count_created DESC', :limit => num)
        pages = []
        page_requests.each do |req|
          pages << Page.find_by_url(req.url)
        end
        pages
      end
      def popularity
        count = PageRequest.find_by_url(url).count_created
        count_max = PageRequest.maximum('count_created')
        popularity = count/count_max.to_f
        result = sprintf("%.0f", popularity * 100)
      end
    end
    
    if admin.respond_to?(:dashboard)
      admin.dashboard.index.add :extensions, 'popular_pages'
    end
  end
  
  def deactivate
    # admin.tabs.remove "Site Watcher"
  end
  
end