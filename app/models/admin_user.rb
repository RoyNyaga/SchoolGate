class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  validates :phone_number, presence: true, length: { is: 12 }
  validates :name, presence: true

  def self.parse_users_info
    all.map { |user| { name: user.name, phone_number: user.phone_number } }
  end
end
