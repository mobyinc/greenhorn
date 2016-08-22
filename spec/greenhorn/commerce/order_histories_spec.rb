require 'spec_helper'

RSpec.describe Greenhorn::Commerce::OrderHistory do
  it 'creates and associates with order' do
    order = Greenhorn::Commerce::Order.create!
    customer = Greenhorn::Commerce::Customer.create!
    history = described_class.create!(order: order, customer: customer)
    expect(history.persisted?).to eq(true)
    expect(history.customer).to eq(customer)
    expect(order.histories).to eq([history])
  end
end
