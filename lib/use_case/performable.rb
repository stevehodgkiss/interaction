module UseCase
  module Performable
    module ClassMethods
      # Executes the use case
      #
      # A use case object is instantiated with the supplied
      # arguments, perform is called and the object is returned.
      #
      # @param args [*args] Arguments to initialize the use case with
      #
      # @return [Object] returns the use case object
      #
      # @since 0.0.1
      # @api public
      def perform(*args)
        new(*args).tap do |use_case|
          use_case.perform
        end
      end
    end

    # Executes use case logic
    #
    # Use cases must implement this method
    #
    # @since 0.0.1
    # @api public
    def perform
      catch :halt do
        super
      end
    end
  end
end
