require 'spec_helper'

RSpec.describe Greenhorn::Commerce::TaxZone do
  it "raises an error when required attributes aren't passed" do
    expect { described_class.create! }.to raise_error(Greenhorn::Errors::MissingAttributeError)
  end

  it 'raises an error when neither states nor countries passed' do
    expect do
      described_class.create!(name: 'Test')
    end.to raise_error(Greenhorn::Errors::MissingAttributeError, 'You must pass either some countries or states')
  end

  it 'raises an error when trying to associate an invalid country' do
    expect do
      described_class.create!(name: 'Asia-Pacific', description: 'testing', countries: %w(ZX))
    end.to raise_error(
      Greenhorn::Errors::InvalidCountryError,
      'ZX does not match any known country name or ISO code'
    )
  end

  it 'raises an error when trying to associate an invalid state' do
    expect do
      described_class.create!(name: 'Midwest', description: 'testing', states: %w(OH IZ))
    end.to raise_error(
      Greenhorn::Errors::InvalidStateError,
      'IZ does not match any known state name or abbreviation'
    )
  end

  it 'raises an error when simultaneously passing countryBased and states' do
    expect do
      described_class.create!(name: 'Asia-Pacific', countryBased: true, states: %w(OH))
    end.to raise_error(Greenhorn::Errors::InvalidOperationError, "Can't assign a state to a country-based tax zone")
  end

  it 'raises an error when simultaneously passing !countryBased and countries' do
    expect do
      described_class.create!(name: 'Midwest', countryBased: false, countries: %w(CN))
    end.to raise_error(Greenhorn::Errors::InvalidOperationError, "Can't assign a country to a state-based tax zone")
  end

  it 'creates' do
    tax_zone = described_class.create!(name: 'Asia-Pacific', description: 'testing', countries: %w(JP CN IN))
    expect(tax_zone.persisted?).to eq(true)
    expect(tax_zone.name).to eq('Asia-Pacific')
    expect(tax_zone.description).to eq('testing')
    expect(tax_zone.countryBased).to eq(true)
    expect(tax_zone.countries).to match_array([
                                                Greenhorn::Commerce::Country.find_by(iso: 'JP'),
                                                Greenhorn::Commerce::Country.find_by(iso: 'CN'),
                                                Greenhorn::Commerce::Country.find_by(iso: 'IN')
                                              ])
  end

  it 'updates' do
    tax_zone = described_class.create!(name: 'Asia-Pacific', description: 'testing', countries: %w(JP CN IN))
    tax_zone.update(countries: %w(CN RU))
    expect(tax_zone.reload.countries).to match_array([
                                                       Greenhorn::Commerce::Country.find_by(iso: 'CN'),
                                                       Greenhorn::Commerce::Country.find_by(iso: 'RU')
                                                     ])
  end

  it 'updates a country-based zone to be state-based' do
    tax_zone = described_class.create!(name: 'Asia-Pacific', description: 'testing', countries: %w(JP CN IN))
    expect do
      tax_zone.update(states: %w(OH IN))
    end.to raise_error(
      Greenhorn::Errors::InvalidOperationError,
      "Can't assign states to a country-based tax zone; pass `countryBased: false` "\
      'if you want to change it, but this will remove all associated countries'
    )
    tax_zone.update(countryBased: false, states: %w(OH IN))
    expect(tax_zone.reload.states).to match_array([
                                                    Greenhorn::Commerce::State.find_by(abbreviation: 'OH'),
                                                    Greenhorn::Commerce::State.find_by(abbreviation: 'IN')
                                                  ])
    expect(tax_zone.countries).to be_empty
  end

  it 'updates a state-based zone to be country-based' do
    tax_zone = described_class.create!(name: 'Midwest', description: 'testing', states: %w(OH IN))
    expect do
      tax_zone.update(countries: %w(CN IN))
    end.to raise_error(
      Greenhorn::Errors::InvalidOperationError,
      "Can't assign countries to a state-based tax zone; pass `countryBased: true` "\
      'if you want to change it, but this will remove all associated states'
    )
    tax_zone.update(countryBased: true, countries: %w(CN IN))
    expect(tax_zone.reload.countries).to match_array([
                                                       Greenhorn::Commerce::Country.find_by(iso: 'CN'),
                                                       Greenhorn::Commerce::Country.find_by(iso: 'IN')
                                                     ])
    expect(tax_zone.states).to be_empty
  end

  it 'raises an error when attempting to assign a country to a state-based zone' do
    tax_zone = described_class.create!(name: 'Midwest', description: 'testing', states: %w(OH IN))
    expect do
      tax_zone.assign_country('IN')
    end.to raise_error(Greenhorn::Errors::InvalidOperationError, "Can't assign a country to a state-based tax zone")
  end

  it 'assigns a country' do
    tax_zone = described_class.create!(name: 'Asia-Pacific', description: 'testing', countries: %w(JP CN))
    tax_zone.assign_country('IN')
    expect(tax_zone.reload.countries).to match_array([
                                                       Greenhorn::Commerce::Country.find_by(iso: 'JP'),
                                                       Greenhorn::Commerce::Country.find_by(iso: 'CN'),
                                                       Greenhorn::Commerce::Country.find_by(iso: 'IN')
                                                     ])
  end

  it 'removes a country' do
    tax_zone = described_class.create!(name: 'Asia-Pacific', description: 'testing', countries: %w(JP CN))
    expect do
      tax_zone.remove_country('IN')
    end.to raise_error("Tried to remove country IN but it isn't assigned to this tax zone")
    expect do
      tax_zone.remove_country('ZZ')
    end.to raise_error("Tried to remove country ZZ but it isn't assigned to this tax zone")
    tax_zone.remove_country('JP')
    expect(tax_zone.reload.countries).to match_array([Greenhorn::Commerce::Country.find_by(iso: 'CN')])
  end

  it 'raises an error when attempting to assign a state to a country-based zone' do
    tax_zone = described_class.create!(name: 'Asia-Pacific', description: 'testing', countries: %w(JP CN))
    expect do
      tax_zone.assign_state('MN')
    end.to raise_error(Greenhorn::Errors::InvalidOperationError, "Can't assign a state to a country-based tax zone")
  end

  it 'assigns a state' do
    tax_zone = described_class.create!(name: 'Midwest', description: 'testing', states: %w(OH IN))
    tax_zone.assign_state('MN')
    expect(tax_zone.reload.states).to match_array([
                                                    Greenhorn::Commerce::State.find_by(abbreviation: 'OH'),
                                                    Greenhorn::Commerce::State.find_by(abbreviation: 'IN'),
                                                    Greenhorn::Commerce::State.find_by(abbreviation: 'MN')
                                                  ])
  end

  it 'removes a state' do
    tax_zone = described_class.create!(name: 'Midwest', description: 'testing', states: %w(OH IN))
    tax_zone.remove_state('IN')
    expect do
      tax_zone.remove_state('PA')
    end.to raise_error("Tried to remove state PA but it isn't assigned to this tax zone")
    expect do
      tax_zone.remove_state('ZZ')
    end.to raise_error("Tried to remove state ZZ but it isn't assigned to this tax zone")
    expect(tax_zone.reload.states).to match_array([Greenhorn::Commerce::State.find_by(abbreviation: 'OH')])
  end

  it 'destroys' do
    tax_zone = described_class.create!(name: 'Midwest', description: 'testing', states: %w(OH IN))
    expect { tax_zone.destroy }.to change(described_class, :count).by(-1)
    expect(tax_zone.persisted?).to eq(false)
  end
end
