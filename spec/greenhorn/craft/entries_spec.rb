require 'spec_helper'

RSpec.describe Greenhorn::Craft::Entry do
  context 'when attempting to create without attributes' do
    it 'raises an exception' do
      expect { Greenhorn::Craft::Entry.create! }.to raise_exception(Greenhorn::Errors::MissingAttributeError)
    end
  end

  context 'when attempting to create without parent or section' do
    it 'raises an exception' do
      expect { Greenhorn::Craft::Entry.create({}) }.to raise_exception(Greenhorn::Errors::MissingAttributeError)
    end
  end

  it 'creates and updates an entry and its content' do
    short_description = Greenhorn::Craft::Field.create!(name: 'Short Description')
    long_description = Greenhorn::Craft::Field.create!(name: 'Long Description')
    section = Greenhorn::Craft::Section.create(name: 'Recipes', fields: [short_description, long_description])
    entry = described_class.create!(
      section: section,
      title: 'Enchiladas',
      shortDescription: 'delicious',
      longDescription: 'super delicious'
    )
    expect(entry.reload.persisted?).to eq(true)
    expect(entry.title).to eq('Enchiladas')
    expect(entry.shortDescription).to eq('delicious')
    expect(entry.longDescription).to eq('super delicious')
  end
end
