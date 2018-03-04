require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:entries).dependent(:destroy) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }

  context 'to validate password' do
    it { should validate_presence_of(:password)  }
    it { should validate_length_of(:password).is_at_least(8).is_at_most(20)  }
  end

  context 'to not validate password' do
    before { allow(subject).to receive(:validate_password?).and_return(false) }
    it { should_not validate_length_of(:password).is_at_least(8).is_at_most(20) }
  end

  # Admin
  it { should have_many(:winners).dependent(:nullify) }
  it { should have_many(:prizes).dependent(:destroy) }
end
