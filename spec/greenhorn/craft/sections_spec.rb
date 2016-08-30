require 'spec_helper'

RSpec.describe Greenhorn::Craft::Section do
  it 'creates with defaults' do
    section = described_class.create!(name: 'Recipes')
    expect(section.reload.persisted?).to eq(true)
    expect(section.channel?).to eq(true)
  end

  it 'creates a section' do
    section = described_class.create!(name: 'Recipes', type: :structure)
    expect(section.reload.persisted?).to eq(true)
    expect(section.structure?).to eq(true)
  end
end
