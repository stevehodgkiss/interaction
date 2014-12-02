module UseCase
  module Performable
    extend ActiveSupport::Concern

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
      def perform(*args)
        use_case = new(*args)
        use_case.perform
        use_case
      end
    end

    # Executes use case logic
    #
    # Use cases must implement this method
    #
    # @since 0.0.1
    def perform
      raise NotImplementedError
    end
  end
end
