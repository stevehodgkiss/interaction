require "active_model"
require "wisper"

require "use_case/version"
require "use_case/validation_helpers"
require "use_case/params"

module UseCase
  def self.included(base)
    base.class_eval do
      prepend Perform
      extend UseCaseClassMethods
      include Params
      include Wisper::Publisher
    end
  end

  include ValidationHelpers

  module Perform
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

  module UseCaseClassMethods
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

  # Indicates if the use case was successful
  #
  # @return [TrueClass, FalseClass]
  #
  # @since 0.0.1
  # @api public
  def success?
    !failed?
  end

  # Indicates whether the use case failed
  #
  # @return [TrueClass, FalseClass]
  #
  # @since 0.0.1
  # @api public
  def failed?
    !!@failed
  end

  # Attach a success callback using wisper
  #
  # @see Wisper
  #
  # @example
  #   use_case = SignUp.new(params)
  #   use_case.on_success do
  #     # handle success
  #   end
  #   use_case.perform
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
  # @example
  #   use_case = SignUp.new(params)
  #   use_case.on_failure do
  #     # handle failure
  #   end
  #   use_case.perform
  #
  # @since 0.0.1
  # @api public
  def on_failure(&block)
    on(namespaced_name(:failure), &block)
  end

  protected

  # Mark the use case as successful and publish the event with
  # Wisper.
  #
  # @return [TrueClass]
  #
  # @since 0.0.1
  # @api public
  def success(args = nil)
    @failed = false
    publish(namespaced_name(:success), args)
    true
  end

  # Mark the use case as failed and publish the event with
  # Wisper.
  #
  # @return [FalseClass]
  #
  # @since 0.0.1
  # @api public
  def failure(args = nil)
    @failed = true
    publish(namespaced_name(:failure), args)
    throw :halt
  end

  # Return an event name namespaced by the underscored class name
  #
  # @return [String]
  #
  # @example
  #   namespaced_event(:success)
  #   # => "sign_up_success"
  #   namespaced_event(:failure)
  #   # => "sign_up_failure"
  #
  # @since 0.0.1
  # @api private
  def namespaced_name(event)
    [model_name.param_key, event].join('_')
  end

  # Halts execution of the use case if validation fails and
  # published errors with Wisper.
  #
  # @since 0.0.1
  # @api public
  def validate!
    failure(errors) unless valid?
  end
end
