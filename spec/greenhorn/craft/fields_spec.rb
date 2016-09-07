require 'spec_helper'

RSpec.describe Greenhorn::Craft::Field do
  let!(:section) { Greenhorn::Craft::Section.create!(name: 'Recipes', fields: [field]) }
  let(:entry) { Greenhorn::Craft::Entry.create({ title: 'blah', section: section }.merge(field_values)) }

  describe 'Lightswitch field' do
    let!(:field) { Greenhorn::Craft::Field.create!(name: 'Featured', type: 'Lightswitch') }

    context 'with no explicit default passed' do
      let(:field_values) { {} }

      it 'defaults to false' do
        pending 'need to implement defaults'
        expect(entry.reload.featured).to eq(false)
      end
    end

    context 'when true' do
      let(:field_values) { { featured: true } }

      it 'saves' do
        expect(entry.reload.featured).to eq(true)
      end
    end

    context 'when false' do
      let(:field_values) { { featured: false } }

      it 'saves' do
        expect(entry.reload.featured).to eq(false)
      end
    end
  end

  describe 'PlainText field' do
    let!(:field) { Greenhorn::Craft::Field.create!(name: 'Short Description') }
    let(:field_values) { { shortDescription: 'blah' } }

    it 'saves' do
      expect(entry.reload.shortDescription).to eq('blah')
    end
  end

  describe 'Richtext field' do
    let!(:field) { Greenhorn::Craft::Field.create!(name: 'Long Description', type: 'RichText') }
    let(:field_values) { { longDescription: 'some seriously rich text' } }

    it 'saves' do
      expect(entry.reload.longDescription).to eq('some seriously rich text')
    end
  end

  describe 'Number field' do
    let!(:field) { Greenhorn::Craft::Field.create!(name: 'Amount', type: 'Number') }
    let(:field_values) { { amount: 5 } }

    it 'saves' do
      expect(entry.reload.amount).to eq(5)
    end
  end

  describe 'Assets field' do
    base_path = File.expand_path('../..', File.dirname(__FILE__))
    images_path = 'images'
    full_images_path = "#{base_path}/#{images_path}"

    before { @connection.extend_config(base_path: base_path) }
    after { FileUtils.rm_rf(full_images_path) }

    let(:source) do
      Greenhorn::Craft::AssetSource.create!(
        name: 'Images',
        type: 'Local',
        path: "{basePath}/#{images_path}",
        publicUrls: false
      )
    end

    let!(:field) do
      Greenhorn::Craft::Field.create!(
        name: 'Images',
        type: 'Assets',
        defaultUploadLocationSource: source,
        singleUploadLocationSource: source,
        allowedKinds: ['image']
      )
    end
    let(:field_values) { { images: File.expand_path('../../files/boat.png', File.dirname(__FILE__)) } }

    it 'saves and updates' do
      expect(entry.reload.images).to match_array(Greenhorn::Craft::AssetFile.where(filename: 'boat.png'))
      entry.update(images: File.expand_path('../../files/tree.jpg', File.dirname(__FILE__)))
      expect(entry.reload.images).to match_array(Greenhorn::Craft::AssetFile.where(filename: 'tree.jpg'))
    end
  end

  describe 'Entries field' do
    let(:ingredients) { Greenhorn::Craft::Section.create(name: 'Ingredients') }
    let(:cilantro) { Greenhorn::Craft::Entry.create(title: 'Cilantro', section: ingredients) }
    let(:cumin) { Greenhorn::Craft::Entry.create(title: 'Cumin', section: ingredients) }
    let(:parsley) { Greenhorn::Craft::Entry.create(title: 'Parsley', section: ingredients) }
    let(:spatula) { Greenhorn::Craft::Entry.create(title: 'Spatula', section: Greenhorn::Craft::Section.create(name: 'Tools')) }
    let(:field) { Greenhorn::Craft::Field.create(name: 'Ingredients', type: 'Entries', sources: [ingredients]) }
    let(:field_values) { { ingredients: [cilantro, cumin] } }

    it 'saves and updates' do
      expect(entry.reload.ingredients).to match_array([cilantro, cumin])
      entry.update(ingredients: [parsley, cumin])
      expect(entry.reload.ingredients).to match_array([parsley, cumin])
    end

    context 'when trying to associate a non-permitted entry type' do
      let(:field_values) { { ingredients: [cilantro, spatula] } }

      it 'raises an error' do
        expect { entry.reload }.to raise_error(Greenhorn::Errors::InvalidOperationError, "Can't attach entry type Tools, allowed entry types: Ingredients")
      end
    end
  end

  describe 'Categories field' do
    let(:cat_group) { Greenhorn::Craft::CategoryGroup.create(name: 'Categories') }
    let(:cat_group2) { Greenhorn::Craft::CategoryGroup.create(name: 'More Categories') }
    let(:cat1) { Greenhorn::Craft::Category.create(title: 'Cat 1', category_group: cat_group) }
    let(:cat2) { Greenhorn::Craft::Category.create(title: 'Cat 2', category_group: cat_group) }
    let(:cat3) { Greenhorn::Craft::Category.create(title: 'Cat 2', category_group: cat_group) }
    let(:other_cat) { Greenhorn::Craft::Category.create(title: 'Other Cat', category_group: cat_group2) }
    let(:field) { Greenhorn::Craft::Field.create!(name: 'Types', type: 'Categories', source: cat_group) }
    let(:field_values) { { types: [cat1, cat2] } }

    it 'saves and updates' do
      expect(entry.reload.types).to match_array([cat1, cat2])
      entry.update(types: [cat1, cat3])
      expect(entry.reload.types).to match_array([cat1, cat3])
    end

    context 'when trying to associate a non-permitted entry type' do
      let(:field_values) { { types: [cat1, other_cat] } }

      it 'raises an error' do
        expect { entry.reload }.to raise_error(
          Greenhorn::Errors::InvalidOperationError,
          "Can't attach category group More Categories, allowed group: Categories"
        )
      end
    end
  end

  describe 'Commerce_Products field' do
    let(:type) { Greenhorn::Commerce::ProductType.create!(name: 'Products') }
    let(:prod1) { Greenhorn::Commerce::Product.create(title: 'Product 1', defaultSku: '1', defaultPrice: 1, type: type) }
    let(:prod2) { Greenhorn::Commerce::Product.create(title: 'Product 2', defaultSku: '2', defaultPrice: 1, type: type) }
    let(:prod3) { Greenhorn::Commerce::Product.create(title: 'Product 3', defaultSku: '3', defaultPrice: 1, type: type) }
    let(:field) { Greenhorn::Craft::Field.create!(name: 'Products', type: 'Commerce_Products') }
    let(:field_values) { { products: [prod1, prod2] } }

    it 'saves and updates' do
      expect(entry.reload.products).to match_array([prod1, prod2])
      entry.update(products: [prod1, prod3])
      expect(entry.reload.products).to match_array([prod1, prod3])
    end
  end

  describe 'Matrix field' do
    let(:field) do
      Greenhorn::Craft::Field.create(
        name: 'Books',
        type: 'Matrix',
        block_types: [
          {
            name: 'Author',
            fields: [
              { name: 'Name' },
              { name: 'Phone', type: 'Number' }
            ]
          }, {
            name: 'Translator',
            fields: [
              { name: 'Name' },
              { name: 'Phone', type: 'Number' }
            ]
          }
        ]
      )
    end
    let(:books) do
      [
        { type: 'author', name: 'Herman Melville', phone: 123456 },
        { type: 'translator', name: 'Mr Translator', phone: 654321 },
        { type: 'author', name: 'Jane Austen', phone: 555123 }
      ]
    end
    let(:field_values) { { books: books } }

    it 'saves and updates' do
      expect(entry.reload.books).to match_array([
        { type: 'author', name: 'Herman Melville', phone: 123456 },
        { type: 'translator', name: 'Mr Translator', phone: 654321 },
        { type: 'author', name: 'Jane Austen', phone: 555123 }
      ])
      entry.update(books: [{ type: 'translator', name: 'Sr Translator', phone: 654321 }])
      expect(entry.reload.books).to match_array([{ type: 'translator', name: 'Sr Translator', phone: 654321 }])
    end
  end
end
