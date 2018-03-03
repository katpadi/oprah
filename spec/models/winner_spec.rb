require 'rails_helper'

RSpec.describe Winner, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:entry) }
  it { should belong_to(:prize) }
end
