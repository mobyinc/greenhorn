require 'spec_helper'

RSpec.describe Greenhorn::Commerce::PaymentMethod do
  it "raises an error when required attributes aren't passed" do
    expect { described_class.create! }.to raise_error(Greenhorn::Errors::MissingAttributeError)
  end

  it 'creates with minimum information' do
    method = described_class.create!(class: 'Stripe', name: 'Stripe')
    expect(method.reload.persisted?).to eq(true)
    expect(method[:class]).to eq('Stripe')
    expect(method.name).to eq('Stripe')
    expect(method.paymentType).to eq('purchase')
    expect(method.frontendEnabled).to eq(false)
    expect(method.isArchived).to eq(false)
  end

  it 'is invalid with a non-purchase/authorize paymentType' do
    method = described_class.create(class: 'Stripe', name: 'Stripe', paymentType: 'blah')
    expect(method.valid?).to eq(false)
    expect(method.errors[:paymentType]).to eq(['must be one of `authorize`, `purchase`'])
  end

  it 'creates with all information' do
    method = described_class.create!(
      class: 'Stripe',
      name: 'Stripe',
      paymentType: 'authorize',
      frontendEnabled: true,
      isArchived: true,
      sortOrder: 5
    )
    expect(method.reload.persisted?).to eq(true)
    expect(method[:class]).to eq('Stripe')
    expect(method.name).to eq('Stripe')
    expect(method.paymentType).to eq('authorize')
    expect(method.frontendEnabled).to eq(true)
    expect(method.isArchived).to eq(true)
    expect(method.sortOrder).to eq(5)
  end
end
