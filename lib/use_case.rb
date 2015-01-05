require "active_model"

require "use_case/version"
require "use_case/module_builder"
require "use_case/validation_helpers"
require "use_case/params"

module UseCase
  # Override Ruby's module inclusion hook to prepend base with our #perform
  # method, extend base with a .perform method, include Params for Virtus and
  # ActiveSupport::Validation.
  #
  # @api private
  def self.included(base)
    base.class_eval do
      prepend Perform
      extend ClassMethods
      include InstanceMethods
      include Params
      include ActiveModel::Validations
    end
  end

  # Includes a customised use case module.
  #
  # @param options [Hash]
  # @option options [TrueClass,FalseClass] :validations
  #
  # @example
  #   include UseCase.use_case(validations: false)
  #
  # @return [Module]
  # @since 0.0.1
  def self.use_case(options = {})
    validations = options.fetch(:validations, true)
    ModuleBuilder.build do
      prepend Perform
      extend ClassMethods
      include InstanceMethods
      include Params
      if validations
        include ActiveModel::Validations
      end
    end
  end

  # Includes a customised params module.
  #
  # @param options [Hash]
  # @option options [TrueClass,FalseClass] :validations
  #
  # @example
  #   include UseCase.params(validations: false)
  #
  # @return [Module]
  # @since 0.0.1
  def self.params(options = {})
    validations = options.fetch(:validations, true)
    ModuleBuilder.build do
      include Params
      if validations
        include ActiveModel::Validations
      end
    end
  end

  include ValidationHelpers

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

  module InstanceMethods
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

    private

    # Mark the use case as successful.
    #
    # @return [TrueClass]
    #
    # @since 0.0.1
    # @api public
    def success(args = nil)
      @failed = false
      true
    end

    # Mark the use case as failed and exits the use case.
    #
    # @return [FalseClass]
    #
    # @since 0.0.1
    # @api public
    def failure(args = nil)
      @failed = true
      throw :halt
    end

    # Halts execution of the use case if validation fails and
    # published errors with Wisper.
    #
    # @since 0.0.1
    # @api public
    def validate!
      failure(errors) unless valid?
    end

    # Indicates whether the use case called success or failure
    #
    # @return [TrueClass, FalseClass]
    #
    # @api private
    # @since 0.0.1
    def result_specified?
      defined?(@failed)
    end
  end
end
