require 'rails_helper'

describe 'EntryPolicy' do
  subject { EntryPolicy.new(user, entry) }

  let(:entry) { FactoryBot.create(:entry, user: user) }
  # let!(:admin_entry) { create(:entry, user: admin) }

  context 'for a guest' do
    let(:user) { FactoryBot.create(:user, role: :guest) }

    it { should_not permit_action(:post) }
    it { should_not permit_action(:put) }
    it { should_not permit_action(:delete) }
    it { should permit_action(:get) }
  end

  context 'for a user, also owner' do
    let(:user) { User.create role: :user }
    let(:entry) { Entry.create(user_id: user.id) }

    it { should permit_action(:post) }
    it { should permit_action(:put) }
    it { should permit_action(:delete) }
    it { should permit_action(:get) }
  end

  context 'for a user' do
    let(:owner) { FactoryBot.create(:user, role: :user) }
    let(:user) { FactoryBot.create(:user, role: :user) }
    let(:entry) { FactoryBot.create(:entry, user: owner) }

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
