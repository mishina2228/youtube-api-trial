# frozen_string_literal: true

module UserSupport
  def user
    User.find_by!(admin: false)
  end

  def admin
    User.find_by!(admin: true)
  end
end
