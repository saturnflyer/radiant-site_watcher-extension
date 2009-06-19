class NotFoundRequest < ActiveRecord::Base
  before_save :increment_count_created
  validates_uniqueness_of :url

  private

  def increment_count_created
    if !self[:count_created].blank?
      self.count_created = self[:count_created] + 1
    else
      self.count_created = 1 if self.new_record?
    end
  end
end
