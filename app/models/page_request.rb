class PageRequest < ActiveRecord::Base
  before_save :increment_count_created
  before_validation :format_url
  
  validates_uniqueness_of :url
  
  def self.find_by_url(url)
    check_url = url
    check_url = url.chop if url.match(/\w+\/$/)
    self.find(:first, :conditions => {:url => check_url})
  end
  
  def self.find_popular(num=25)
    page_requests = PageRequest.find(:all, :order => 'count_created DESC, virtual ASC', :conditions => ['count_created > 1 and (ignore is NULL or ignore = ?)', false], :limit => num)
  end
  
  def self.reset_counts
    PageRequest.update_all("count_created = 0")
  end
  
  def popularity
    count_max = PageRequest.maximum('count_created')
    popularity = count_created/count_max.to_f
    result = sprintf("%.0f", popularity * 100)
  end
  
  private
  
  def increment_count_created
    if !self[:count_created].blank?
      self.count_created = self[:count_created] + 1
    else
      self.count_created = 1 if self.new_record?
    end
  end
  
  def format_url
    unless self[:url].match(/^\/\w*/)
      self[:url] = "/#{self[:url]}"
    end
  end
end
