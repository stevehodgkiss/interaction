module UseCase::ValidationHelpers
  private

  # Halts execution of the use case if validation fails and
  # published errors with Wisper.
  #
  # @since 0.0.1
  # @api public
  def validate!
    failure unless valid?
  end

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
