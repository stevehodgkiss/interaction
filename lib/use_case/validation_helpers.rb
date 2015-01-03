module UseCase::ValidationHelpers
  private

  # Merges errors from another
  # ActiveModel::Validations object with itself
  #
  # @param object [ActiveModel::Validations]
  #
  # @api public
  def merge_errors(object)
    object.errors.each do |attribute, value|
      errors.add(attribute, value)
    end
  end
end
