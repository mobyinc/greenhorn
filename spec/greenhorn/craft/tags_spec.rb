require 'spec_helper'

RSpec.describe Greenhorn::Craft::Tag do
  it 'creates and finds' do
    tag = described_class.create!(slug: 'test', tag_group: Greenhorn::Craft::TagGroup.create!(name: 'Test'))
    expect(tag.reload.persisted?).to eq(true)
    expect(tag.slug).to eq('test')
  end
end
