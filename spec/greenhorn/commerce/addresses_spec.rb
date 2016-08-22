require 'spec_helper'

RSpec.describe Greenhorn::Commerce::Address do
  it "raises an error when required attributes aren't passed" do
    expect { described_class.create! }.to raise_error(Greenhorn::Errors::MissingAttributeError)
  end

  it 'creates with minimum information' do
    address = described_class.create!(firstName: 'Jane', lastName: 'Doe')
    expect(address.persisted?).to eq(true)
  end

  it 'creates with all information' do
    united_states = Greenhorn::Commerce::Country.find_by(iso: 'US')
    washington = Greenhorn::Commerce::State.find_by(abbreviation: 'WA')
    address = described_class.create!(
      firstName: 'Jane',
      lastName: 'Doe',
      address1: '3401 Fremont Ave N',
      address2: 'Suite 241',
      city: 'Seattle',
      country: united_states,
      state: washington,
      zipCode: '98103',
      phone: '555-555-5555',
      alternativePhone: '555-555-5555',
      businessName: 'Moby, Inc',
      businessTaxId: 'moby-1',
      stateName: 'Washington'
    )
    expect(address.persisted?).to eq(true)
    expect(address.firstName).to eq('Jane')
    expect(address.lastName).to eq('Doe')
    expect(address.address1).to eq('3401 Fremont Ave N')
    expect(address.address2).to eq('Suite 241')
    expect(address.city).to eq('Seattle')
    expect(address.state).to_not be_nil
    expect(address.state).to eq(washington)
    expect(address.country).to_not be_nil
    expect(address.country).to eq(united_states)
    expect(address.zipCode).to eq('98103')
    expect(address.phone).to eq('555-555-5555')
    expect(address.alternativePhone).to eq('555-555-5555')
    expect(address.businessName).to eq('Moby, Inc')
    expect(address.businessTaxId).to eq('moby-1')
    expect(address.stateName).to eq('Washington')
  end
end
