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

  it 'finds by field' do
    short_description = Greenhorn::Craft::Field.create!(name: 'Short Description')
    long_description = Greenhorn::Craft::Field.create!(name: 'Long Description')
    section = Greenhorn::Craft::Section.create(name: 'Recipes', fields: [short_description, long_description])
    entry = described_class.create!(
      section: section,
      title: 'Enchiladas',
      shortDescription: 'delicious',
      longDescription: 'super delicious'
    )

    expect(described_class.find_by(section: section)).to eq(entry)
    expect(described_class.find_by(section: section, shortDescription: 'delicious')).to eq(entry)
    expect(described_class.find_by(section: section, longDescription: 'super delicious')).to eq(entry)
    expect(described_class.find_by(section: section, shortDescription: 'delicious', longDescription: 'super delicious')).to eq(entry)
    expect(described_class.find_by(section: section, shortDescription: 'blah')).to be_nil
  end

  it 'converts to hash with field values' do
    short_description = Greenhorn::Craft::Field.create!(name: 'Short Description')
    long_description = Greenhorn::Craft::Field.create!(name: 'Long Description')
    matrix = Greenhorn::Craft::Field.create(
      name: 'Many Books',
      type: 'Matrix',
      block_types: [
        { name: 'Author', fields: [ { name: 'Name' }, { name: 'Phone', type: 'Number' } ] },
        { name: 'Translator', fields: [ { name: 'Name' }, { name: 'Phone', type: 'Number' } ] }
      ]
    )
    tag_group = Greenhorn::Craft::TagGroup.create(name: 'Support')
    support_tags = Greenhorn::Craft::Field.create(
      name: 'Support Tags',
      type: 'Tags',
      source: tag_group
    )
    section = Greenhorn::Craft::Section.create(name: 'Recipes', fields: [short_description, long_description, matrix, support_tags])
    attrs = {
      section: section,
      title: 'Enchiladas',
      shortDescription: 'delicious',
      longDescription: 'super delicious',
      manyBooks: [
        { type: 'author', name: 'Herman Melville', phone: 123456 },
        { type: 'translator', name: 'Mr Translator', phone: 654321 }
      ],
      supportTags: [
        Greenhorn::Craft::Tag.create!(tag_group: tag_group, title: 'Tag 1'),
        Greenhorn::Craft::Tag.create!(tag_group: tag_group, title: 'Tag 2')
      ]
    }
    entry = described_class.create!(attrs)
    hash = entry.to_h
    expect(hash).to include(
      id: entry.id,
      title: 'Enchiladas',
      shortDescription: 'delicious',
      longDescription: 'super delicious',
      dateCreated: entry.dateCreated,
      dateUpdated: entry.dateUpdated,
      postDate: entry.postDate,
      uid: entry.uid
    )
    expect(hash[:manyBooks].map { |tag| tag[:name] }).to eq(['Herman Melville', 'Mr Translator'])
    expect(hash[:supportTags].map { |tag| tag[:title] }).to eq(['Tag 1', 'Tag 2'])
  end
end
