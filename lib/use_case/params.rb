require 'virtus'
require 'active_support/core_ext/hash/reverse_merge'

module UseCase
  module Params
    extend ActiveSupport::Concern

    included do
      include Virtus.model(strict: true)
      extend AttributeOverride
    end

    module AttributeOverride
      # Overrides Virtus' attribute method to default required to false
      def attribute(name, type, options = {})
        super(name, type, options.reverse_merge(required: false))
      end
    end
  end
end
