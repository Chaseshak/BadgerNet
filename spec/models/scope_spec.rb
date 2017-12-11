require 'rails_helper'

RSpec.describe Scope, type: :model do
  it 'has a valid factory' do
    expect(build(:scope)).to be_valid
  end

  let(:scope) { build(:scope) }

  describe 'ActiveRecord associations' do
    it { expect(scope.role).to be_valid }
  end

  describe 'public class methods' do
    context 'responds to its methods' do
      it { expect(Scope).to respond_to(:remove_event_scope) }
      it { expect(Scope).to respond_to(:backfill_event_scope) }
    end

    context 'executes its methods correctly' do
      context 'remove_event_scope' do
        it 'removes all events scoped with the current user and role' do
          user = create(:user)
          role = create(:role)
          user.add_role role.name
          user.schedule = create(:schedule)
          # scope the events
          Scope.backfill_event_scope(user, role)
          expect(Scope.count).to eq(3)

          # Test removing the scope
          Scope.remove_event_scope(user, role)
          expect(Scope.count).to eq(0)
        end

        it 'returns nil when schedule is not defined' do
          user = create(:user)
          expect(Scope.remove_event_scope(user, nil)).to be nil
        end
      end

      context 'backfill_event_scope' do
        it 'scopes all event for the current user and role' do
          user = create(:user)
          role = create(:role)
          user.add_role role.name
          user.schedule = create(:schedule)
          # scope the events
          Scope.backfill_event_scope(user, role)
          expect(Scope.count).to eq(3)
        end

        it 'returns nil when schedule is not defined' do
          user = create(:user)
          expect(Scope.backfill_event_scope(user, nil)).to be nil
        end
      end
    end
  end
end
