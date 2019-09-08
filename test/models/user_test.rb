require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def test_validation
    user = User.new(valid_params)
    assert user.valid?
    assert user.save

    user = User.new(valid_params.merge(email: nil))
    assert user.invalid?

    user = User.new(valid_params)
    assert user.invalid?, 'emailでユニークであること'
  end

  def valid_params
    {
      email: 'test_user1@example.com',
      password: 'password1',
      admin: true
    }
  end
end
