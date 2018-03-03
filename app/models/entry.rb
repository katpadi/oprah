class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :prize

  validates :comment, presence: true, length: { maximum: 280 }

  # Pagination defaults
  paginates_per 10
  max_paginates_per 30
end
