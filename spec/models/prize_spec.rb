require 'rails_helper'

RSpec.describe Prize, type: :model do
  it { should have_many(:entries).dependent(:destroy) }
  it { should have_many(:winners).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:name) }
end
