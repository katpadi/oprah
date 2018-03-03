require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:entries).dependent(:destroy) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }

  # Admin
  it { should have_many(:winners).dependent(:nullify) }
  it { should have_many(:prizes).dependent(:destroy) }
end
