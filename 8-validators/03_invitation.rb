class Invitation < ActiveRecord::Base
  validates :recipient_email, presence: true, email: true
end
