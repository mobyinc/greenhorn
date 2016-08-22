require 'spec_helper'

RSpec.describe Greenhorn::Commerce::OrderStatus do
  it 'is invalid without minimum information' do
    order_status = described_class.create
    expect(order_status.valid?).to eq(false)
    expect(order_status.errors[:name]).to eq(["can't be blank"])
  end

  it 'creates and infers a handle' do
    order_status = described_class.create(name: 'Backordered')
    expect(order_status.reload.persisted?).to eq(true)
    expect(order_status.name).to eq('Backordered')
    expect(order_status.handle).to eq('backordered')
  end
end
