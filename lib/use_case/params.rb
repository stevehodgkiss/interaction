require 'virtus'
require 'active_support/core_ext/hash/reverse_merge'

module UseCase
  # Provides attribute definition and strict type coersion with virtus and
  # validations with Active Model
  module Params
    extend ActiveSupport::Concern

    included do
      include Virtus.model(strict: true)
      extend AttributeOverride

      include ActiveModel::Conversion
      include ActiveModel::Validations
    end

    module AttributeOverride
      # Overrides Virtus' attribute method to default required to false
      def attribute(name, type, options = {})
        super(name, type, options.reverse_merge(required: false))
      end

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
