require 'spec_helper'

RSpec.describe Greenhorn::Craft::User do
  it 'is invalid without minimum information' do
    user = described_class.create
    expect(user.valid?).to eq(false)
    expect(user.errors[:username]).to eq(["can't be blank"])
    expect(user.errors[:email]).to eq(["can't be blank"])
  end

  it 'creates with minimum information' do
    user = described_class.create!(email: 'ahab@mobyinc.com', username: 'ahab')
    expect(user.reload.persisted?).to eq(true)
    expect(user.username).to eq('ahab')
    expect(user.email).to eq('ahab@mobyinc.com')
  end
end
