module UseCase
  # Allows easy customisation of the included block.
  #
  # @example
  #   options = {}
  #   ModuleCustomiser.build do
  #     if options.fetch(:validations, true)
  #       include ActiveSupport::Validations
  #     end
  #   end
  class ModuleCustomiser
    def self.build(&block)
      Module.new.tap do |mod|
        mod.define_singleton_method(:included) do |base|
          base.class_eval(&block)
        end
      end
    end
  end
end
