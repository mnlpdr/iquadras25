class NotificationLog < ApplicationRecord
  belongs_to :user
  belongs_to :reservation, optional: true

  validates :notification_type, presence: true
  validates :status, presence: true

  enum :status, { pending: "pending", sent: "sent", failed: "failed" }
end
