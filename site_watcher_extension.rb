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
      include SiteWatcher::PageExtension
    end
    
    if admin.respond_to?(:dashboard)
      admin.dashboard.index.add :extensions, 'popular_pages'
    end
  end
  
  def deactivate
    # admin.tabs.remove "Site Watcher"
  end
  
end