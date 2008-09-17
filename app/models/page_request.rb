class PageRequest < ActiveRecord::Base
  validates_uniqueness_of :url
  
  def self.find_by_url(url)
    check_url = url
    check_url = url.chop if url.match(/\w+\/$/)
    check_url = check_url[1..-1] if check_url.match(/^\/\w+/)
    self.find(:first, :conditions => {:url => check_url})
  end
  
  def self.find_popular(num=25)
    page_requests = PageRequest.find(:all, :order => 'count_created DESC', :limit => num)
  end
  
  def popularity
    count_max = PageRequest.maximum('count_created')
    popularity = count_created/count_max.to_f
    result = sprintf("%.0f", popularity * 100)
  end
end
