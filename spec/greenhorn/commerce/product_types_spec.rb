require 'spec_helper'

RSpec.describe Greenhorn::Commerce::ProductType do
  describe '#create' do
    it 'raises an error with no attributes' do
      expect { described_class.create! }.to raise_error(Greenhorn::Errors::MissingAttributeError)
    end

    it 'raises an error with no name' do
      expect { described_class.create!({}) }.to raise_error(Greenhorn::Errors::MissingAttributeError)
    end

    it 'saves and updates a new record' do
      product_type = described_class.create(
        name: 'Books',
        fields: [Greenhorn::Craft::Field.create(name: 'Description')]
      )
      expect(product_type.persisted?).to eq(true)
      expect(product_type.name).to eq('Books')
      expect(product_type.handle).to eq('books')
      product_type.update(name: 'Rare Books')
      expect(product_type.reload.name).to eq('Rare Books')
    end
  end
end
