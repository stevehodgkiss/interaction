require "active_support/concern"
require "active_model"
require "use_case/version"
require "use_case/performable"
require "use_case/succeedable"
require "use_case/validation_helpers"
require "use_case/params"
require "use_case/form_object"

module UseCase
  extend ActiveSupport::Concern

  included do
    include ActiveModel::Validations
  end

  include Performable
  include Succeedable
  include Params
  include ValidationHelpers
end
