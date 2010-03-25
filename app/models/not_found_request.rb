class NotFoundRequest < ActiveRecord::Base
  before_save :increment_count_created
  validates_uniqueness_of :url
  has_many :bad_directions
  has_many :bad_referrers, :through => :bad_directions

  private

  def increment_count_created
    if !self[:count_created].blank?
      self.count_created = self[:count_created] + 1
    else
      self.count_created = 1 if self.new_record?
    end
  end
end
