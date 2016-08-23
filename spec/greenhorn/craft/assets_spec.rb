require 'spec_helper'

RSpec.describe Greenhorn::Craft::AssetFile do
  base_path = File.expand_path('../..', File.dirname(__FILE__))
  images_path = 'asset_images'
  full_images_path = "#{base_path}/#{images_path}"

  before { @connection.extend_config(base_path: base_path) }
  after { FileUtils.rm_rf(full_images_path) }

  let(:local_source) do
    Greenhorn::Craft::AssetSource.create!(
      type: 'Local',
      name: 'Images',
      path: "{basePath}/#{images_path}",
      publicUrls: false,
      fields: [
        Greenhorn::Craft::Field.create!(name: 'Short Description')
      ]
    )
  end

  describe 'create and update' do
    context 'with local storage' do
      let(:test_image) { 'https://homepages.cae.wisc.edu/~ece533/images/boat.png' }

      it 'persists the record and saves file to local path' do
        file = described_class.create!(
          file: test_image,
          asset_folder: local_source.asset_folder,
          shortDescription: 'hello'
        )
        expect(file.persisted?).to eq(true)
        expect(file.reload.shortDescription).to eq('hello')
        expect(file.title).to eq('boat.png')
        expect(File.exist?("#{full_images_path}/boat.png")).to eq(true)

        file.update(shortDescription: 'goodbye')
        expect(file.reload.shortDescription).to eq('goodbye')
      end
    end

    context 'with S3' do
      pending
    end
  end
end
