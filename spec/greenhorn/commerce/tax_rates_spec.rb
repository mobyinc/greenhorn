require 'spec_helper'

RSpec.describe Greenhorn::Commerce::TaxRate do
  it "raises an error when required attributes aren't passed" do
    expect { described_class.create! }.to raise_error(Greenhorn::Errors::MissingAttributeError)
  end

  let(:tax_zone) { Greenhorn::Commerce::TaxZone.create(name: 'Zone 1', states: ['WA'], default: true) }

  it 'creates with defaults' do
    tax_rate = described_class.create(name: 'Seattle', tax_zone: tax_zone)
    expect(tax_rate.persisted?).to eq(true)
    expect(tax_rate.tax_zone).to eq(tax_zone)
    expect(tax_rate.rate).to eq(0.05)
    expect(tax_rate.taxable).to eq('price')
    expect(tax_rate.tax_category).to eq(Greenhorn::Commerce::TaxCategory.default)
  end

  it 'creates with non-defaults' do
    tax_category = Greenhorn::Commerce::TaxCategory.create!(name: 'Test')
    tax_rate = described_class.create!(
      name: 'Seattle',
      rate: 0.7,
      taxable: 'price_shipping',
      tax_category: tax_category,
      tax_zone: tax_zone,
      include: true,
      showInLabel: true
    )
    expect(tax_rate.persisted?).to eq(true)
    expect(tax_rate.tax_zone).to eq(tax_zone)
    expect(tax_rate.rate).to eq(0.7)
    expect(tax_rate.taxable).to eq('price_shipping')
    expect(tax_rate.include).to eq(true)
    expect(tax_rate.showInLabel).to eq(true)
    expect(tax_rate.tax_category).to eq(tax_category)
  end

  it 'raises an error if there is no default tax category and none is passed' do
    Greenhorn::Commerce::TaxCategory.destroy_all
    expect do
      described_class.create(name: 'Seattle', tax_zone: tax_zone)
    end.to raise_error(
      Greenhorn::Errors::MissingAttributeError,
      'You must pass a tax category if there is no default'
    )
  end

  it 'is invalid if setting includedInPrice on non-default tax zone' do
    tax_zone = Greenhorn::Commerce::TaxZone.create(name: 'Zone 2', states: ['WA'])
    tax_rate = described_class.create(name: 'Seattle', tax_zone: tax_zone, include: true)
    expect(tax_rate.valid?).to eq(false)
    expect(tax_rate.errors[:include]).to eq(['can only be set if using the default tax zone'])
  end
end
