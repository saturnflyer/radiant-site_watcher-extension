# Uncomment this if you reference any of your controllers in activate
require_dependency 'application_controller'

class SiteWatcherExtension < Radiant::Extension
  version "1.0"
  description "Records a count of the number of times each page's cache is created."
  url "http://saturnflyer.com/"
  
  define_routes do |map|
    map.namespace :admin do |admin|
      admin.destroy_all_page_requests "/page_requests/destroy_all", :controller => 'page_requests', :action => 'destroy_all', :conditions => {:method => :delete}
      admin.dashboard_page_request '/dashboard/page_requests', :controller => 'page_requests', :action => 'index'
      admin.page_request "/page_request/:id", :controller => 'page_requests', :action => 'destroy', :conditions => {:method => :delete}
      admin.ignore_page_request "/page_request/:id/ignore", :controller => 'page_requests', :action => 'ignore', :conditions => {:method => :put}
      admin.not_found_request "/not_found_request/:id", :controller => 'not_found_requests', :action => 'destroy', :conditions => {:method => :delete}
      admin.resources :bad_directions
    end
  end
  
  def activate
    SiteController.send :include, SiteWatcher::PageTrack
    Page.class_eval do
      include PopularPageTags
      include SiteWatcher::PageExtension
    end
    
    if admin.respond_to?(:dashboard)
      admin.dashboard.index.add :extensions, 'bad_directions'
      admin.dashboard.index.add :extensions, 'not_found_pages'
      admin.dashboard.index.add :extensions, 'popular_pages'
    end
  end
  
  def deactivate
    # admin.tabs.remove "Site Watcher"
  end
  
end