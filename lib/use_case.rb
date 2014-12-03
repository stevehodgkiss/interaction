require "active_support/concern"
require "active_model"
require "use_case/version"
require "use_case/performable"
require "use_case/succeedable"
require "use_case/validation_helpers"
require "use_case/params"

module UseCase
  extend ActiveSupport::Concern
  include Performable
  include Succeedable
  include ActiveModel::Validations
  include ValidationHelpers
  include Params
end
