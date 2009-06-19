class PageRequest < ActiveRecord::Base
  before_save :increment_count_created
  after_save :record_not_found
  before_validation :format_url
  
  validates_uniqueness_of :url
  
  def self.find_by_url(url)
    check_url = url
    check_url = url.chop if url.match(/\w+\/$/)
    self.find(:first, :conditions => {:url => check_url})
  end
  
  def self.find_popular(num=25)
    if ActiveRecord::Base.connection.adapter_name.downcase == 'mysql'
      page_requests = PageRequest.find(:all, :order => 'count_created DESC, virtual ASC', :conditions => ['count_created > 1 and (`ignore` is ? or `ignore` = ?)', nil, false], :limit => num)
    else
      page_requests = PageRequest.find(:all, :order => 'count_created DESC, virtual ASC', :conditions => ['count_created > 1 and (ignore is ? or ignore = ?)', nil, false], :limit => num)
    end
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
  
  def record_not_found
    @page = Page.find_by_url(self[:url])
    if @page.kind_of?(FileNotFoundPage) || @page.nil?
      @not_found = NotFoundRequest.find_or_initialize_by_url(:url => self[:url])
      @not_found.save
    end
  end
end
