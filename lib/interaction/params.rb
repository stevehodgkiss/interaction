require 'virtus'

module Interaction
  # Uses Virtus for whitelisting and type coercion.
  #
  # Virtus is configured in strict mode to ensure input is coerced to either
  # the specified type or nil.
  #
  # @example
  #   class SignUpForm
  #     include Interaction::Params
  #
  #     attribute :name, String
  #   end
  #
  #   SignUpForm.new(name: 'John Smith').name
  #   # => "John Smith"
  #
  #   SignUpForm.new(name: ['a']) # => Virtus::CoercionError
  #
  #   SignUpForm.new.name
  #   # => nil
  module Params
    def self.included(base)
      base.class_eval do
        include Virtus.model(strict: true, required: false)
      end
    end
  end
end
