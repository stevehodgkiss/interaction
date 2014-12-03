module UseCase
  module FormObject
    extend ActiveSupport::Concern
    include Params
    include ActiveModel::Model
  end
end
