require "active_support/all"
require "active_model"
require "use_case/version"
require "use_case/succeedable"
require "use_case/validations"
require "use_case/params"

module UseCase
  extend ActiveSupport::Concern
  include Succeedable
  include Validations
  include Params

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
