# UseCase

Provides a convention for modelling user interactions as use case classes. A
use case class represents and is named after something a user does with your
application `SignUp`, `RequestResetPasswordEmail` etc.

Attributes are whitelisted and coerced into an expected type using Virtus. An
attribute will either be the specified type or nil.

Take a look at the [code itself](https://github.com/stevehodgkiss/use_case/blob/master/lib/use_case.rb) for full details of the API provided.

## A simple example

```ruby
class SignUp
  include UseCase
  include UseCase::ValidationHelpers
  include ActiveModel::Validations

  # Virtus
  attribute :email, String
  attribute :password, String

  # ActiveModel validations
  validate :email, :password, presence: true

  attr_reader :user

  def perform
    validate!
    create_user
    deliver_welcome_email
  end

  private

  def create_user
    @user = User.create!(attributes)
  end
end

sign_up = SignUp.perform(username: 'john', password: 'j0hn')
sign_up.success?
# => true
sign_up.user
# => #<User id:...>
```
