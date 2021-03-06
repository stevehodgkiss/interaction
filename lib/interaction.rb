require "interaction/version"
require "interaction/params"
require "interaction/validation_helpers"

module Interaction
  # Override Ruby's module inclusion hook to prepend base with #perform,
  # extend base with a .perform method, and include Params for Virtus.
  #
  # @api private
  def self.included(base)
    base.class_eval do
      prepend Perform
      extend ClassMethods
      include Params
    end
  end

  module Perform
    # Executes use case logic
    #
    # Use cases must implement this method. Assumes success if failure is not
    # called.
    #
    # @since 0.0.1
    # @api public
    def perform
      catch :halt do
        super.tap do
          success unless result_specified?
        end
      end
    end
  end

  module ClassMethods
    # Executes and returns the use case
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
    !!@success
  end

  # Indicates whether the use case failed
  #
  # @return [TrueClass, FalseClass]
  #
  # @since 0.0.1
  # @api public
  def failed?
    !success?
  end

  private

  # Mark the use case as successful.
  #
  # @return [TrueClass]
  #
  # @since 0.0.1
  # @api public
  def success
    @success = true
  end

  # Mark the use case as failed.
  #
  # @since 0.0.1
  # @api public
  def failure
    @success = false
  end

  # Mark the use case as failed and exits the use case.
  #
  # @since 0.0.1
  # @api public
  def failure!
    failure
    throw :halt
  end

  # Indicates whether the use case called success or failure
  #
  # @return [TrueClass, FalseClass]
  #
  # @api private
  # @since 0.0.1
  def result_specified?
    defined?(@success)
  end
end
