module UseCase::ValidationHelpers
  private

  # Halts execution of the use case if validation fails. Assumes
  # #valid? is implemented by the chosen validation library.
  #
  # @since 0.0.1
  # @api public
  def validate!
    failure unless valid?
  end

  # Merges errors from another
  # ActiveModel::Validations object with itself, assuming
  # ActiveModel::Validations has been included.
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
