class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  scope :admin, -> {where(admin: true)}
  scope :genuine, -> {where('email not like "%@example.com"')}
  scope :should_notify, -> {admin.genuine}
end
