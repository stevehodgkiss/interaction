require 'active_model/validations'

module UseCase::Validations
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  private

  # Merges errors from another
  # ActiveModel::Validations object with itself
  #
  # @param object [ActiveModel::Validations]
  def merge_errors(object)
    object.errors.each do |attribute, value|
      errors.add(attribute, value)
    end
  end
end
