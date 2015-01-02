require "active_support/concern"
require "active_model"
require "wisper"

require "use_case/version"
require "use_case/performable"
require "use_case/succeedable"
require "use_case/validation_helpers"
require "use_case/params"

module UseCase
  extend ActiveSupport::Concern

  included do
    prepend Performable
    extend Performable::ClassMethods
  end

  include Succeedable
  include Params
  include ValidationHelpers
end
