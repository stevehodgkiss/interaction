require 'virtus'

module UseCase
  # Uses Virtus for whitelisting, coerce and validate user input.
  #
  # Virtus is configured in strict mode to ensure input is coerced to either the specified type or nil.
  #
  # @example
  #   class SignUpForm
  #     include UseCase::Params
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
    def self.included(base)
      base.class_eval do
        include Virtus.model(strict: true, required: false)
      end
    end
  end
end
