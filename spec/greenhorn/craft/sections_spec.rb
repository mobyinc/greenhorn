require 'spec_helper'

RSpec.describe Greenhorn::Craft::Section do
  it "raises an error when required attributes aren't passed" do
    expect { described_class.create! }.to raise_error(Greenhorn::Errors::MissingAttributeError)
  end

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
