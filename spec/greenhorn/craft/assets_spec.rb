require 'spec_helper'

RSpec.describe Greenhorn::Craft::AssetFile do
  base_path = File.expand_path('../..', File.dirname(__FILE__))
  images_path = 'asset_images'
  full_images_path = "#{base_path}/#{images_path}"

  after { FileUtils.rm_rf(full_images_path) }

  context 'with local storage' do
    let(:asset_source) do
      Greenhorn::Craft::AssetSource.create!(
        type: 'Local',
        name: 'Images',
        path: "{basePath}/#{images_path}",
        publicUrls: false
      )
    end
    let(:test_image) { 'https://homepages.cae.wisc.edu/~ece533/images/boat.png' }

    it 'persists the record and saves file to local path' do
      @connection.extend_config(base_path: base_path)
      file = described_class.create!(file: test_image, asset_folder: asset_source.asset_folder)
      expect(file.persisted?).to eq(true)
      expect(File.exist?("#{full_images_path}/boat.png")).to eq(true)
    end
  end
end
