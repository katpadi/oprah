class Winner < ApplicationRecord
  belongs_to :user
  belongs_to :prize
  belongs_to :entry
end
