require "active_support/all"
require "active_model"
require "use_case/version"
require "use_case/validations"
require "use_case/form"

module UseCase
  extend ActiveSupport::Concern
  include Validations

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
