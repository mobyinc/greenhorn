require 'greenhorn/craft/base_model'

module Greenhorn
  module Craft
    class User < BaseModel
      include ContentBehaviors

      class << self
        def table
          'users'
        end

        # Creates a new user
        #
        # @param attrs [Hash]
        # @option attrs [String] username
        # @option attrs [String] email
        # @option attrs [String] photo (nil)
        # @option attrs [String] firstName (nil)
        # @option attrs [String] lastName (nil)
        # @option attrs [String] password (nil)
        # @option attrs [String] preferredLocale (nil)
        # @option attrs [String] weekStartDay (nil)
        # @option attrs [String] admin (nil)
        # @option attrs [String] client (nil)
        # @option attrs [String] locked (nil)
        # @option attrs [String] suspended (nil)
        # @option attrs [String] pending (nil)
        # @option attrs [String] archived (nil)
        # @option attrs [DateTime] lastLoginDate (nil)
        # @option attrs [String] lastLoginAttemptIPAddress (nil)
        # @option attrs [DateTime] lastLoginWindowStart (nil)
        # @option attrs [Integer] invalidLoginCount (nil)
        # @option attrs [DateTime] lastInvalidLoginDate (nil)
        # @option attrs [DateTime] lockoutDate (nil)
        # @option attrs [String] verificationCode (nil)
        # @option attrs [DateTime] verificationCodeIssuedDate (nil)
        # @option attrs [String] unverifiedEmail (nil)
        # @option attrs [Boolean] passwordResetRequired (false)
        # @option attrs [DateTime] lastPasswordChangeDate (nil)
        # @return [User]
        #
        # @example Create a user
        #   User.create!(email: 'ahab@mobyinc.com', username: 'ahab')
        def create(attrs = {})
          super(attrs)
        end
      end

      validates :email, :username, presence: true

      before_create do
        create_element(type: 'Order')
      end

      # Creates a new user
      #
      # @param attrs [Hash]
      # @option attrs [String] username
      # @option attrs [String] email
      # @option attrs [String] photo (nil)
      # @option attrs [String] firstName (nil)
      # @option attrs [String] lastName (nil)
      # @option attrs [String] password (nil)
      # @option attrs [String] preferredLocale (nil)
      # @option attrs [String] weekStartDay (nil)
      # @option attrs [String] admin (nil)
      # @option attrs [String] client (nil)
      # @option attrs [String] locked (nil)
      # @option attrs [String] suspended (nil)
      # @option attrs [String] pending (nil)
      # @option attrs [String] archived (nil)
      # @option attrs [DateTime] lastLoginDate (nil)
      # @option attrs [String] lastLoginAttemptIPAddress (nil)
      # @option attrs [DateTime] lastLoginWindowStart (nil)
      # @option attrs [Integer] invalidLoginCount (nil)
      # @option attrs [DateTime] lastInvalidLoginDate (nil)
      # @option attrs [DateTime] lockoutDate (nil)
      # @option attrs [String] verificationCode (nil)
      # @option attrs [DateTime] verificationCodeIssuedDate (nil)
      # @option attrs [String] unverifiedEmail (nil)
      # @option attrs [Boolean] passwordResetRequired (false)
      # @option attrs [DateTime] lastPasswordChangeDate (nil)
      # @return [User]
      def update(attrs)
        super(attrs)
      end

      # @!visibility private
      def initialize(attrs)
        super(attrs)
      end

      # @!visibility private
      def assign_attributes(attrs)
        super(attrs)
      end

      # Removes an existing user
      #
      # @return [User]
      def destroy
        super
      end

      def field_layout
        Greenhorn::Craft::FieldLayout.find_by(type: 'User')
      end
    end
  end
end
