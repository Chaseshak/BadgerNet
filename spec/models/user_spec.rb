require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  describe 'ActiveModel validations' do
    it 'requires a first name, last name, and phone number' do
      expect(build(:user, first_name: '')).not_to be_valid
      expect(build(:user, last_name: '')).not_to be_valid
      expect(build(:user, phone: '')).not_to be_valid
    end

    it 'requires a 10 digit US Phone number' do
      expect(build(:user, phone: '123')).not_to be_valid
    end
  end
end
