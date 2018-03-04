class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :prize

  validates :comment, presence: true, length: { maximum: 280 }

  # Pagination defaults
  paginates_per 10
  max_paginates_per 30

  scope :winnable, -> { where(won_at: nil) }

  def won?
    won_at.present?
  end
end
