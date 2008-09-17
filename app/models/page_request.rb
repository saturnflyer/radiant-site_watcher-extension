class PageRequest < ActiveRecord::Base
  validates_uniqueness_of :url
  
  def self.find_by_url(url)
    check_url = url
    check_url = url.chop if url.match(/\w+\/$/)
    check_url = check_url[1..-1] if check_url.match(/^\/\w+/)
    self.find(:first, :conditions => {:url => check_url})
  end
end
