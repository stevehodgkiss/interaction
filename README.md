# UseCase

Provides a convention for modelling user interactions as use case classes. A
use case represents something a user does with your application, and is named
as a verb. SignUp, RequestResetPasswordEmail etc.

This library is mostly glue around [Virtus](https://github.com/solnic/virtus),
[ActiveModel::Validations](http://api.rubyonrails.org/classes/ActiveModel/Validations.html)
and [Wisper](https://github.com/krisleech/wisper) to provide a convention for
writing use cases.  Virtus is used for parameter declaration and strict type
coersion.  ActiveModel::Validations is used for validations and Wisper for
publish and subscribe events.

## Type coercion

Whitelisting and sanitizing untrusted input into an expected type before it
enters your application is good practice. Input is coerced into the type
specified using Virtus. You can expect an attribute to be either the defined
type or nil.

## Sign up example

Use Form objects when the input is complex or you want to bind it to a Rails
form. Attributes can also be defined on use case classes.

```ruby
class SignUpForm
  include UseCase::Params
  param_key 'sign_up'

  attribute :username, String
  attribute :password, String
  attribute :password_confirmation, String

  # Context free validations
  validates :username, :email, :password, presence: true
  validates :password, confirmation: true

  validates :password_is_strong

  private

  def password_is_strong
    # ...
  end
end
```

The use case interacts with the rest of your application to complete the use case. Implement #perform and call `success` or `failure` with any arguments. Those arguments are sent to subscribers of the events.

```ruby
class SignUp
  include UseCase

  def initialize(form)
    @form = form
  end

  validate :form_is_valid

  # Contextual validations
  validate :username_is_unique

  def perform
    validate!
    create_user
    deliver_welcome_email
    success(@user)
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

  def form_is_valid
    merge_errors(@form) unless @form.valid?
  end

  def create_user
    @user = User.create(form.attributes)
    failure unless @user.persisted?
  end

  def deliver_welcome_email
    UserMailer.deliver_signup_confirmation(@user)
  end
end
```

## Usage inside a Rails controller

```ruby
class UsersController < ApplicationController
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
end
```

## Global subscribers

```ruby
class LogSubscriber
  def sign_up_success(user)
    Rails.logger.info("Signed up user")
  end
end
SignUp.subscribe(LogSubscriber.new)
```

## Block subscribers

```ruby
use_case = SignUp.new(form)
use_case.on_success do |user|
  # ...
end
use_case.on_failure do
end
use_case.perform
```

## Contributing

1. Fork it ( http://github.com/stevehodgkiss/use_case/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
