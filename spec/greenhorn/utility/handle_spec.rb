require 'spec_helper'

RSpec.describe Greenhorn::Utility::Handle do
  it 'removes everything except letters' do
    expect(described_class.new('9329ab@cdef   g\2233223h% ^ i  j      k\ @@').to_s).to eq('abcdefGhIJK')
  end

  it 'camel-cases' do
    expect(described_class.new('one two three').to_s).to eq('oneTwoThree')
  end
end
