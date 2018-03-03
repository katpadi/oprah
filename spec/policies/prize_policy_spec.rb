require 'rails_helper'

describe 'PrizePolicy' do
  subject { PrizePolicy.new(user, prize) }

  let(:prize) { FactoryBot.create(:prize) }

  context 'for a guest' do
    let(:user) { FactoryBot.create(:user, role: :guest) }

    it { should_not permit_action(:post) }
    it { should_not permit_action(:put) }
    it { should_not permit_action(:delete) }
    it { should permit_action(:get) }
  end

  context 'for a user, also owner' do
    let(:user) { User.create role: :user }
    let(:prize) { Prize.create(user_id: user.id) }
    it { should permit_action(:post) }
    it { should permit_action(:put) }
    it { should permit_action(:delete) }
    it { should permit_action(:get) }
  end

  context 'for a user' do
    let(:user) { FactoryBot.create(:user, role: :user) }

    it { should permit_action(:post) }
    it { should_not permit_action(:put) }
    it { should_not permit_action(:delete) }
    it { should permit_action(:get) }
  end

  context 'for an admin' do
    let(:user) { FactoryBot.create(:user, role: :admin) }

    it { should permit_action(:post) }
    it { should permit_action(:put) }
    it { should permit_action(:delete) }
    it { should permit_action(:get) }
  end
end
