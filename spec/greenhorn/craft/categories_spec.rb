require 'spec_helper'

RSpec.describe Greenhorn::Craft::Category do
  describe 'create with multiple locales' do
    let(:category_group) { Greenhorn::Craft::CategoryGroup.create!(name: 'Group') }
    let!(:french) { Greenhorn::Craft::Locale.create!(locale: 'fr') }

    it 'saves and adds locale records' do
      category = described_class.create!(title: 'Test', category_group: category_group)
      expect(category.reload.locales.map(&:locale)).to eq(['en_us', 'fr'])
      expect(category.contents.map(&:title)).to eq(['Test', 'Test'])
    end
  end
end
