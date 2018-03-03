require 'rails_helper'

RSpec.describe Entry, type: :model do
  # Association test
  # ensure an entry record belongs to a single prize and user record
  it { should belong_to(:prize) }
  it { should belong_to(:user) }
  # Validation tests
  # ensure columns title and created_by are present before saving
  # it { should validate_presence_of(:title) }
  # it { should validate_presence_of(:created_by) }

  it { should validate_presence_of(:comment) }
end
