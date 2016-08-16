require 'spec_helper'

RSpec.describe Greenhorn::Commerce::TaxCategory do
  it 'creates a new tax category' do
    default_tax_category = described_class.find_or_create_by(name: 'General', default: true)
    tax_category = described_class.create!(name: 'Main', description: 'testing')
    expect(tax_category.persisted?).to eq(true)
    expect(tax_category.handle).to eq('main')
    expect(tax_category.description).to eq('testing')
    expect(tax_category.default).to eq(false)
    expect(default_tax_category.reload.default).to eq(true)
  end

  it 'creates a new default category and de-associates old default' do
    default_tax_category = described_class.find_or_create_by(name: 'General', default: true)
    tax_category = described_class.create!(name: 'New Default', default: true)
    expect(tax_category.persisted?).to eq(true)
    expect(tax_category.default).to eq(true)
    expect(default_tax_category.reload.default).to eq(false)
  end
end
