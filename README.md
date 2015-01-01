# UseCase

Provides a convention for writing use case interactor classes. Uses Virtus for parameter declaration and type coersion. Uses ActiveModel::Validations for validations.

Conventions to follow:

- Use cases live in app/use_cases
- Name use cases classes as verbs, i.e. SignUp or RequestPasswordResetEmail
- Use a Form Object as input to use cases when a rails form is involved or the input is complex enough to warrant a separate object.

## Example

```ruby
class SignUpForm
  include UseCase::Params

  # Virtus is included with strict mode enabled, although `attribute` is
overridden to default to `required: false` in order to allow nil values without
a Virtus exception.
  # Therefore attribute values will be either the specified type or nil

  attribute :username, String
  attribute :password, String
  attribute :password_confirmation, String

  # UseCase includes ActiveModel::Validations
  # Context free validations live inside the form object
  validates :username, :email, :password, presence: true
  validates :password, confirmation: true

  validates :password_is_strong

  private

  def password_is_strong
    # ...
  end
end

class SignUp
  include UseCase

  def initialize(form)
    @form = form
  end

  validate :form_is_valid

  # Contextual validations live inside the use case
  validate :username_is_unique, :password_hasnt_been_used_before_for_this_user

  def perform
    if valid? # It's the use cases responsibility to validate data and handle the invalid scenario
      @user = User.create!(form.attributes)
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

  private

  def username_is_unique
    errors.add(:username, 'is taken') if User.username_taken?(username)
  end

  def password_hasnt_been_used_before_for_this_user
    # ...
  end

  def form_is_valid
    merge_errors(@form) unless @form.valid?
  end
end

# Usage inside a Rails controller
before_filter :load_form, only: [:new, :create]

def create
  use_case = SignUp.perform(@form)
  if use_case.success?
    redirect_to use_case.user
  else
    flash.now[:error] = use_case.error_message
    render :new
  end
end

private

def load_form
  @form = SignUpForm.new(params)
end
```

## Contributing

1. Fork it ( http://github.com/stevehodgkiss/use_case/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
