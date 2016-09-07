require 'spec_helper'

RSpec.describe Greenhorn::Craft::CategoryGroup do
  describe 'create with multiple locales' do
    let!(:french) { Greenhorn::Craft::Locale.create!(locale: 'fr') }

    it 'saves and adds locale records' do
      group = described_class.create!(name: 'Group')
      expect(group.reload.locales.map(&:locale)).to eq(['en_us', 'fr'])
      expect(group.hasUrls).to eq(false)
    end
  end
end
