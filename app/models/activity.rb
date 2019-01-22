class Activity < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :locations, dependent: :destroy
  scope :user_activities, ->(actual_user) { where(user_id: actual_user) }
end
