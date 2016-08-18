require 'greenhorn/commerce/base_model'

module Greenhorn
  module Commerce
    class TaxZone < BaseModel
      class << self
        # @!visibility private
        def table
          'commerce_taxzones'
        end

        # Finds the default tax zone, if any
        #
        # @return [TaxZone]
        def default
          find_by(default: 1)
        end

        # Creates a new tax zone
        #
        # @param attrs [Hash]
        # @option attrs [String] name The tax zone's name
        # @option attrs [Array] countries An array of country names or ISO codes
        # @option attrs [Array] states An array of state names or abbreviations
        # @option attrs [Boolean] countryBased (inferred) Whether the zone is country-based
        # @return [TaxZone]
        #
        # @example Create a country-based tax zone with country names
        #   TaxZone.create(name: 'Asia-Pacific', countries: ['China', 'India', 'Japan'])
        # @example Create a country-based tax zone with country ISO codes
        #   TaxZone.create(name: 'Asia-Pacific', countries: ['CN', 'IN', 'JP'])
        # @example Create a state-based tax zone with state names
        #   TaxZone.create(name: 'Midwest', states: ['Ohio', 'Indiana'])
        # @example Create a state-based tax zone with state abbreviations
        #   TaxZone.create(name: 'Midwest', states: ['OH', 'IN'])
        def create(attrs)
          super(attrs)
        end
      end

      has_many :associated_countries, foreign_key: 'taxZoneId', class_name: 'TaxZoneCountry'
      has_many :associated_states, foreign_key: 'taxZoneId', class_name: 'TaxZoneState'
      has_many :countries, through: :associated_countries
      has_many :states, through: :associated_states

      after_save do
        if @countries.present?
          clear_jurisdictions
          @countries.each { |country| assign_country(country) }
        end

        if @states.present?
          clear_jurisdictions
          @states.each { |state| assign_state(state) }
        end
      end

      # Updates an existing tax zone
      #
      # @param attrs [Hash]
      # @option attrs [String] name The tax zone's name
      # @option attrs [Array] countries An array of country names or ISO codes
      # @option attrs [Array] states An array of state names or abbreviations
      # @option attrs [Boolean] countryBased (inferred) Whether the zone is country-based
      # @return [TaxZone]
      #
      # @example Change a preexisting country-based tax zone to state-based
      #   tax_zone.update(name: 'Midwest', states: ['OH', 'IN'])
      def update(attrs)
        super(attrs)
      end

      # @!visibility private
      def initialize(attrs)
        require_attributes!(attrs, %i(name))
        if attrs[:countries].nil? && attrs[:states].nil?
          raise Greenhorn::Errors::MissingAttributeError, 'You must pass either some countries or states'
        end

        if attrs[:countryBased].nil?
          if attrs[:countries].present?
            attrs[:countryBased] = true
          elsif attrs[:states].present?
            attrs[:countryBased] = false
          end
        end

        super(attrs)
      end

      # @!visibility private
      def assign_attributes(attrs)
        @countries = attrs.delete(:countries)
        @states = attrs.delete(:states)

        if !countryBased.nil? && attrs[:countryBased].nil?
          if countryBased && @states.present?
            raise Greenhorn::Errors::InvalidOperationError,
                  "Can't assign states to a country-based tax zone; pass `countryBased: false` "\
                  'if you want to change it, but this will remove all associated countries'
          elsif !countryBased && @countries.present?
            raise Greenhorn::Errors::InvalidOperationError,
                  "Can't assign countries to a state-based tax zone; pass `countryBased: true` "\
                  'if you want to change it, but this will remove all associated states'
          end
        end

        super(attrs)
      end

      # Removes an existing tax zone
      #
      # @return [TaxZone]
      def destroy
        super
      end

      # Assigns a country to the tax zone
      #
      # @param [String] name_or_iso The full country name or short ISO code (e.g., "India" or "IN")
      # @return [TaxZoneCountry] The new country association
      #
      # @example Assign a country using its full name
      #   tax_zone.assign_country('India')
      # @example Assign a country using its ISO code
      #   tax_zone.assign_country('IN')
      def assign_country(name_or_iso)
        raise Greenhorn::Errors::InvalidOperationError,
              "Can't assign a country to a state-based tax zone" unless countryBased
        country = Greenhorn::Commerce::Country.find_by_name_or_iso(name_or_iso)
        raise Greenhorn::Errors::InvalidCountryError, name_or_iso if country.nil?
        associated_countries.find_or_create_by(country: country)
      end

      # Removes an associated country
      #
      # @param [String] name_or_iso The full country name or short ISO code (e.g., "India" or "IN")
      # @return [TaxZoneCountry] The removed country association
      #
      # @example Remove a country using its full name
      #   tax_zone.remove_country('India')
      # @example Remove a country using its ISO code
      #   tax_zone.remove_country('IN')
      def remove_country(name_or_iso)
        country = Country.find_by_name_or_iso(name_or_iso)
        associated_country = associated_countries.find_by(country: country)
        if associated_country.nil?
          raise Greenhorn::Errors::InvalidOperationError,
                "Tried to remove country #{name_or_iso} but it isn't assigned to this tax zone"
        end
        associated_country.destroy
      end

      # Assigns a state to the tax zone
      #
      # @param [String] name_or_abbr The full state name or abbreviation (e.g., "Indiana" or "IN")
      # @return [TaxZoneState] The new state association
      #
      # @example Assign a state using its full name
      #   tax_zone.assign_state('Indiana')
      # @example Assign a state using its abbreviation
      #   tax_zone.assign_state('IN')
      def assign_state(name_or_abbr)
        raise Greenhorn::Errors::InvalidOperationError,
              "Can't assign a state to a country-based tax zone" if countryBased
        state = Greenhorn::Commerce::State.find_by_name_or_abbr(name_or_abbr)
        raise Greenhorn::Errors::InvalidStateError, name_or_abbr if state.nil?
        associated_states.find_or_create_by(state: state)
      end

      # Removes an associated state
      #
      # @param [String] name_or_abbr The full state name or abbreviation (e.g., "Indiana" or "IN")
      # @return [TaxZoneState] The removed state association
      #
      # @example Remove a state using its full name
      #   tax_zone.remove_state('Indiana')
      # @example Remove a state using its abbreviation
      #   tax_zone.remove_state('IN')
      def remove_state(name_or_abbr)
        state = State.find_by_name_or_abbr(name_or_abbr)
        associated_state = associated_states.find_by(state: state)
        if associated_state.nil?
          raise Greenhorn::Errors::InvalidOperationError,
                "Tried to remove state #{name_or_abbr} but it isn't assigned to this tax zone"
        end
        associated_state.destroy
      end

      private

      def clear_jurisdictions
        associated_countries.destroy_all
        associated_states.destroy_all
      end
    end
  end
end
