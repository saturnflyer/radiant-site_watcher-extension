class BadReferrer < ActiveRecord::Base
  validates_uniqueness_of :url
  has_many :bad_directions
  has_many :not_found_requests, :through => :bad_directions
end
