require 'spec_helper'

RSpec.describe Greenhorn::Commerce::Customer do
  it 'creates with minimum information' do
    customer = described_class.create!
    expect(customer.persisted?).to eq(true)
  end

  it 'creates with full information' do
    user = Greenhorn::Craft::User.create!(email: 'ahab@mobyinc.com', username: 'ahab')
    shipping_address = Greenhorn::Commerce::Address.create!(firstName: 'Jane', lastName: 'Doe')
    billing_address = Greenhorn::Commerce::Address.create!(firstName: 'Jane', lastName: 'Doe')
    customer = described_class.create!(
      user: user,
      email: 'ahab@mobyinc.com',
      last_used_shipping_address: shipping_address,
      last_used_billing_address: billing_address
    )
    expect(customer.reload.persisted?).to eq(true)
    expect(customer.user).to eq(user)
    expect(customer.last_used_shipping_address).to eq(shipping_address)
    expect(customer.last_used_billing_address).to eq(billing_address)
    expect(customer.email).to eq('ahab@mobyinc.com')
  end
end
