module UseCase
  # Indicate the result of a use case
  #
  # @example
  #
  #   class SignUp
  #     include UseCase
  #
  #     attribute :name, String
  #     attribute :password, String
  #     attribute :password_confirmation, String
  #
  #     validates :name, presence: true
  #
  #     attr_reader :user
  #
  #     def perform
  #       if valid?
  #         @user = User.create(name: name)
  #         success(@user)
  #       else
  #         failure
  #       end
  #     end
  #   end
  #
  #   class LogSubscriber
  #     def sign_up_success(user)
  #       Rails.logger.info("Signed up user")
  #     end
  #   end
  #   SignUp.subscribe(LogSubscriber.new)
  #
  #   use_case = SignUp.perform(name: 'John Smith')
  #   use_case.success?
  #   # => true
  #   use_case.failed?
  #   # => false
  #
  #   use_case = SignUp.new(name: 'John Smith')
  #   use_case.on_success do |user|
  #     # ...
  #   end
  #   use_case.on_failure do |user|
  #     # ...
  #   end
  #   use_case.perform
  #
  # @see Wisper::Publisher
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

    # Attach a success callback using wisper
    #
    # @see Wisper
    #
    # @since 0.0.1
    # @api public
    def on_success(&block)
      on(namespaced_name(:success), &block)
    end

    # Attach a failure callback
    #
    # @see Wisper
    #
    # @since 0.0.1
    # @api public
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
      throw :halt
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
