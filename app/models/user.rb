# A user is a user of the application, default devise class
class User < ApplicationRecord
  has_one :schedule, dependent: :destroy
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable
  validates :first_name, :last_name, :phone, presence: true
  validates :phone, format: { with: /\A(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-.]\d{4})\z/,
                              message: 'Please enter a 10 digit US Phone Number' }

  def coach?
    has_role? :coach
  end

  def delete_role(role)
    return false unless has_role?(role)
    begin
      remove_role role
    # rubocop:disable Lint/HandleExceptions
    rescue ActiveRecord::HasManyThroughAssociationNotFoundError
    end
    # rubocop:enable Lint/HandleExceptions
    !has_role?(role)
  end

  def first_name
    self[:first_name].capitalize if self[:first_name]
  end

  def last_name
    self[:last_name].capitalize if self[:last_name]
  end
end
