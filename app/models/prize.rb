class Prize < ApplicationRecord
  has_many :entries, dependent: :destroy
  has_many :winners, dependent: :destroy
  belongs_to :user
  validates_presence_of :name

  # Pagination defaults
  paginates_per 10
  max_paginates_per 30
end
