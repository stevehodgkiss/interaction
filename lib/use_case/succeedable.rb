module UseCase
  module Succeedable
    # Indicates if the use case was successful
    #
    # @return [TrueClass, FalseClass]
    #
    # @since 0.0.1
    def success?
      !failed?
    end

    # Indicates whether the use case failed
    #
    # @return [TrueClass, FalseClass]
    #
    # @since 0.0.1
    def failed?
      @failed
    end

    private

    # Mark the use case as successful
    #
    # @return [TrueClass, FalseClass]
    #
    # @since 0.0.1
    def success
      @failed = false
      true
    end

    # Mark the use case as failed
    #
    # @return [TrueClass, FalseClass]
    #
    # @since 0.0.1
    def failure
      @failed = true
      false
    end
  end
end
