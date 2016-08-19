require 'spec_helper'

RSpec.describe Greenhorn::Commerce::Product do
  describe '#create' do
    it 'raises an error with no attributes' do
      expect { described_class.create! }.to raise_error(Greenhorn::Errors::MissingAttributeError)
    end

    it 'raises an error with no title' do
      expect { described_class.create!({}) }.to raise_error(Greenhorn::Errors::MissingAttributeError)
    end

    context 'when the product type has variants enabled' do
      let!(:short_description) { Greenhorn::Craft::Field.create!(name: 'Short Description') }
      let!(:long_description) { Greenhorn::Craft::Field.create!(name: 'Long Description') }
      let(:product_type) { Greenhorn::Commerce::ProductType.create!(name: 'Books', hasVariants: true, fields: %w(shortDescription longDescription)) }
      let!(:default_tax_category) { Greenhorn::Commerce::TaxCategory.create!(name: 'Default', default: true) }

      it 'creates and updates a record with fields' do
        product = described_class.create(
          title: 'Moby Dick',
          defaultSku: 'moby-dick',
          defaultPrice: 9,
          type: product_type,
          shortDescription: 'Man + whale',
          longDescription: 'A story about a whale'
        )
        expect(product.reload.shortDescription).to eq('Man + whale')
        expect(product.reload.longDescription).to eq('A story about a whale')
        product.update(longDescription: 'A long story about a whale')
        expect(product.reload.longDescription).to eq('A long story about a whale')
        expect(product.reload.shortDescription).to eq('Man + whale')
      end

      it 'saves a new record with a default variant without explicit variant attrs' do
        product = described_class.create(
          title: 'Moby Dick',
          defaultSku: 'moby-dick',
          defaultPrice: 9,
          type: product_type
        )
        expect(product.persisted?).to eq(true)
        expect(product.title).to eq('Moby Dick')
        expect(product.defaultSku).to eq('moby-dick')
        expect(product.defaultPrice).to eq(9)
        expect(product.type).to eq(product_type)
        expect(product.tax_category).to eq(default_tax_category)
        expect(product.promotable).to eq(true)

        default_variant = product.default_variant
        expect(default_variant.persisted?).to eq(true)
        expect(default_variant.title).to eq('Moby Dick')
        expect(default_variant.sku).to eq('moby-dick')
        expect(default_variant.price).to eq(9)
        expect(default_variant.stock).to eq(0)
        expect(default_variant.unlimitedStock).to eq(true)
      end

      it 'saves a new record with a default variant with explicit variant attrs' do
        product = described_class.create(
          title: 'Moby Dick',
          defaultSku: 'moby-dick',
          defaultPrice: 9,
          type: product_type,
          default_variant_attrs: {
            title: 'Moby Dick Variant',
            sku: 'moby-dick2',
            price: 8,
            unlimitedStock: false,
            stock: 10
          }
        )
        expect(product.persisted?).to eq(true)
        expect(product.title).to eq('Moby Dick')
        expect(product.defaultSku).to eq('moby-dick')
        expect(product.defaultPrice).to eq(9)
        expect(product.type).to eq(product_type)

        default_variant = product.default_variant
        expect(default_variant.persisted?).to eq(true)
        expect(default_variant.title).to eq('Moby Dick Variant')
        expect(default_variant.sku).to eq('moby-dick2')
        expect(default_variant.price).to eq(8)
        expect(default_variant.stock).to eq(10)
        expect(default_variant.unlimitedStock).to eq(false)
      end
    end

    context 'when the product type has variants disabled' do
      let(:product_type) { Greenhorn::Commerce::ProductType.create!(name: 'Books', hasVariants: false) }

      it 'saves a record with no default variant' do
        product = described_class.create(
          title: 'Moby Dick',
          defaultSku: 'moby-dick',
          defaultPrice: 9,
          type: product_type
        )
        expect(product.default_variant).to be_nil
      end
    end
  end
end
