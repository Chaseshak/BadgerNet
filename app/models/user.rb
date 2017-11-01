# A user is a user of the application, default devise class
class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :first_name, :last_name, :phone, presence: true
  validates :phone, format: { with: /\d{10}/,
                              message: 'Please enter a 10 digit US Phone Number' }
end
