# UseCase

Provides a convention for modelling user interactions as use case classes. A
use case class represents and is named after something a user does with your
application `SignUp`, `RequestResetPasswordEmail` etc.

## Type coercion

Whitelisting and sanitizing untrusted input into an expected type before it
enters your application is a good practice. Attributes are defined and coerced
with Virtus. An attribute will either be the defined type or nil.

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

## Contributing

1. Fork it ( http://github.com/stevehodgkiss/use_case/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
