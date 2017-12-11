require 'rails_helper'

RSpec.describe Role, type: :model do
  it 'has a valid factory' do
    expect(build(:role)).to be_valid
  end

  let(:role) { build(:role) }

  describe 'ActiveRecord Associations' do
    it { expect(role).to belong_to(:resource) }
  end

  describe 'public class methods' do
    context 'responds to its methods' do
      it { expect(Role).to respond_to(:non_permissions_roles) }
    end

    context 'executes its methods correctly' do
      context 'non_permissions_roles' do
        it 'returns the non-permissions roles' do
          create(:role)
          create(:athlete_role)
          expect(Role.non_permissions_roles.count).to eq(1)
        end
      end
    end
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { expect(role).to respond_to(:cap_name) }
    end

    context 'executes its methods correctly' do
      context 'cap_name' do
        it 'returns the capital role name' do
          expect(role.cap_name).to eq(role.name.capitalize)
        end
      end
    end
  end
end
