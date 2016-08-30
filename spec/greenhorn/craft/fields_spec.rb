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
    let(:field) { Greenhorn::Craft::Field.create(name: 'Ingredients', type: 'Entries', sources: [ingredients]) }
    let(:cilantro) { Greenhorn::Craft::Entry.create(title: 'Cilantro', section: ingredients) }
    let(:cumin) { Greenhorn::Craft::Entry.create(title: 'Cumin', section: ingredients) }
    let(:parsley) { Greenhorn::Craft::Entry.create(title: 'Parsley', section: ingredients) }
    let(:field_values) { { ingredients: [cilantro, cumin] } }

    it 'saves and updates' do
      expect(entry.reload.ingredients).to match_array([cilantro, cumin])
      entry.update(ingredients: [parsley, cumin])
      expect(entry.reload.ingredients).to match_array([parsley, cumin])
    end
  end
end
