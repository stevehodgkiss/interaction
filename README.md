# UseCase

Provides a convention for writing use case interactor classes.

## Example

```ruby
class SignUp
  include UseCase

  # Whitelist attributes and specify a type
  # The attribute will then be either the specified type or nil
  attribute :username, String
  attribute :password, String

  # UseCase includes ActiveModel::Validations
  validates :username, :email, :password, presence: true
  validate :username_is_unique

  def perform
    if valid?
      @user = User.create!(attributes)
      UserMailer.deliver_signup_confirmation(@user)
    else
      failure
    end
  end

  # Expose objects to the controller/other callers
  attr_reader :user

  def error_message
    errors.full_messages.to_sentence
  end
end

# Usage
use_case = SignUp.perform(username: 'test', password: 'test')
if use_case.success?
  redirect_to use_case.user
else
  render :new
end
```

## Contributing

1. Fork it ( http://github.com/stevehodgkiss/use_case/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
