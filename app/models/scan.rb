class Scan < ApplicationRecord
  belongs_to :good
  validates :qr_data, presence: true
  validates :scanned_at, presence: true
end
