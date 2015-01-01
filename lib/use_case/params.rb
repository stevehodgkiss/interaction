require 'virtus'
require 'active_support/core_ext/hash/reverse_merge'

module UseCase
  # Whitelisting, coerce and validate user input.
  #
  # Uses Virtus and ActiveModel::Validations.
  #
  # Virtus is configured in strict mode to ensure input is coerced to either the specified type or nil.
  #
  # @example
  #   class SignUpForm
  #     include UseCase::Params
  #
  #     param_key 'sign_up'
  #
  #     attribute :name, String
  #
  #     validates :name, presence: true
  #   end
  #
  #   form = SignUpForm.new(name: 'John Smith')
  #   form.valid? # => true
  #
  #   form = SignUpForm.new(name: ['a']) # => Virtus::CoercionError
  module Params
    extend ActiveSupport::Concern

    included do
      include Virtus.model(strict: true)
      extend AttributeOverride

      include ActiveModel::Conversion
      include ActiveModel::Validations
    end

    module AttributeOverride
      # Specify an attribute and it's type
      #
      # @param name [String] the name of the attribute
      # @param type [Class] the type of the attribute
      # @param options [Hash] options to be passed to Virtus
      #
      # @see Virtus::Extensions::Methods.attribute
      #
      # @since 0.0.1
      # @api public
      def attribute(name, type, options = {})
        super(name, type, options.reverse_merge(required: false))
      end

      # Set the active model name to be used for partial paths
      # and form keys in Rails.
      #
      # @since 0.0.1
      # @api public
      def param_key(name)
        class_eval <<-RUBY
          def self.model_name
            @model_name ||= ActiveModel::Name.new(self, nil, "#{name}")
          end
        RUBY
      end
    end
  end
end
