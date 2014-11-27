require 'virtus'

module UseCase
  module Params
    extend ActiveSupport::Concern

    included do
      include Virtus.model(strict: true)
      extend AttributeOverride
    end

    module AttributeOverride
      # Overrides Virtus attribute method to always set
      # required to false if required isn't specified
      def attribute(name, type, options = {})
        super(name, type, options.reverse_merge(required: false))
      end
    end
  end
end
