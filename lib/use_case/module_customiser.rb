module UseCase
  # Allows easy customisation of the included block.
  #
  # @example
  #   options = {}
  #   ModuleCustomiser.new do
  #     if options.fetch(:validations, true)
  #       include ActiveSupport::Validations
  #     end
  #   end
  class ModuleCustomiser < Module
    def initialize(&block)
      @block = block
    end

    def included(base)
      base.class_eval(&@block)
    end
  end
end
