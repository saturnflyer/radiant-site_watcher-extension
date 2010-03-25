class BadDirection < ActiveRecord::Base
  belongs_to :bad_referrer
  belongs_to :not_found_request
end
