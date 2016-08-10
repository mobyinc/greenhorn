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

  pending 'creates and updates an entry and its content'
end
