module UseCase
  module FormObject
    extend ActiveSupport::Concern

    included do
      include ActiveModel::Model
      include Params
    end
  end
end
