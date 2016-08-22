require 'spec_helper'

RSpec.describe Greenhorn::Commerce::Order do
  it 'creates with minimum information' do
    default_status = Greenhorn::Commerce::OrderStatus.default
    order = described_class.create!
    expect(order.persisted?).to eq(true)
    expect(order.number.length).to eq(32)
    expect(order.status).to_not be_nil
    expect(order.status).to eq(default_status)
  end

  it 'attaches and removes fields from the order field layout' do
    delivery_instructions = Greenhorn::Craft::Field.create!(name: 'Delivery Instructions')
    described_class.add_field(delivery_instructions)
    expect(described_class.field?('deliveryInstructions')).to eq(true)
    described_class.remove_field(delivery_instructions)
    expect(described_class.field?('deliveryInstructions')).to eq(false)
  end

  it 'creates with all information' do
    described_class.add_field(Greenhorn::Craft::Field.create!(name: 'Delivery Instructions'))
    billing_address = Greenhorn::Commerce::Address.create!(firstName: 'Jane', lastName: 'Doe')
    shipping_address = Greenhorn::Commerce::Address.create!(firstName: 'Jane', lastName: 'Doe')
    payment_method = Greenhorn::Commerce::PaymentMethod.create!(class: 'Stripe', name: 'Stripe')
    shipped_status = Greenhorn::Commerce::OrderStatus.find_by(name: 'Shipped')
    customer = Greenhorn::Commerce::Customer.create!
    order = described_class.create!(
      number: 'overridden',
      shipping_address: shipping_address,
      billing_address: billing_address,
      payment_method: payment_method,
      customer: customer,
      status: shipped_status,
      couponCode: 'coupon1',
      itemTotal: 19.73,
      baseDiscount: 3,
      baseShippingCost: 5,
      totalPrice: 25,
      email: 'test@mobyinc.com',
      isCompleted: true,
      dateOrdered: Date.yesterday,
      datePaid: Date.today,
      currency: 'USD',
      lastIp: 'testIp',
      message: 'message',
      returnUrl: 'returnUrl',
      cancelUrl: 'cancelUrl',
      shippingMethod: 'first',
      deliveryInstructions: 'call when here'
    )
    expect(order.persisted?).to eq(true)
    expect(order.number).to eq('overridden')
    expect(order.billing_address).to eq(billing_address)
    expect(order.shipping_address).to eq(shipping_address)
    expect(order.payment_method).to eq(payment_method)
    expect(order.customer).to eq(customer)
    expect(order.status).to_not be_nil
    expect(order.status).to eq(shipped_status)
    expect(order.couponCode).to eq('coupon1')
    expect(order.status).to eq(shipped_status)
    expect(order.itemTotal).to eq(19.73)
    expect(order.baseDiscount).to eq(3)
    expect(order.baseShippingCost).to eq(5)
    expect(order.totalPrice).to eq(25)
    expect(order.email).to eq('test@mobyinc.com')
    expect(order.isCompleted).to eq(true)
    expect(order.dateOrdered).to eq(Date.yesterday)
    expect(order.datePaid).to eq(Date.today)
    expect(order.currency).to eq('USD')
    expect(order.lastIp).to eq('testIp')
    expect(order.message).to eq('message')
    expect(order.returnUrl).to eq('returnUrl')
    expect(order.cancelUrl).to eq('cancelUrl')
    expect(order.shippingMethod).to eq('first')
    expect(order.deliveryInstructions).to eq('call when here')
  end
end
