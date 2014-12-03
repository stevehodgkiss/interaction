module UseCase
  module FormObject
    extend ActiveSupport::Concern

    included do
      include ActiveModel::Model
    end

    include Params
  end
end
