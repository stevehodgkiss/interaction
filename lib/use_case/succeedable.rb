module UseCase
  module Succeedable
    include Wisper::Publisher

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
      !!@failed
    end

    # Attach a success callback
    #
    # @since 0.0.1
    def on_success(&block)
      on(namespaced_name(:success), &block)
    end

    # Attach a failure callback
    #
    # @since 0.0.1
    def on_failure(&block)
      on(namespaced_name(:failure), &block)
    end

    private

    # Mark the use case as successful
    #
    # @return [TrueClass]
    #
    # @since 0.0.1
    def success(args = nil)
      @failed = false
      publish(namespaced_name(:success), args)
      true
    end

    # Mark the use case as failed
    #
    # @return [FalseClass]
    #
    # @since 0.0.1
    def failure(args = nil)
      @failed = true
      publish(namespaced_name(:failure), args)
      false
    end

    # Return an event name namespaced by the underscored class name
    #
    # @return [String]
    #
    # @since 0.0.1
    def namespaced_name(event)
      [model_name.param_key, event].join('_')
    end
  end
end
