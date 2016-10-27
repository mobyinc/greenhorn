require 'spec_helper'

RSpec.describe Greenhorn::Commerce::Email do
  it 'creates and infers a handle' do
    email = described_class.create(name: 'Test Email', to: 'test', templatePath: 'template', subject: 'Test')
    expect(email.reload.persisted?).to eq(true)
    expect(email.name).to eq('Test Email')
  end
end
