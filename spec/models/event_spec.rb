require 'rails_helper'

RSpec.describe Event, type: :model do
  it 'has a valid factory' do
    expect(build(:event)).to be_valid
  end

  let(:event) { create(:event) }

  describe 'ActiveModel validations' do
    it { expect(event).to validate_presence_of(:name) }
    it { expect(event).to validate_presence_of(:start_time) }
    it { expect(event).to validate_presence_of(:end_time) }
  end

  describe 'ActiveRecord assocations' do
    it { expect(event).to belong_to(:schedule) }
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { expect(event).to respond_to(:days_as_string) }
      it { expect(event).to respond_to(:time_length) }
    end

    context 'executes its methods correctly' do
      context 'days_as_string' do
        let(:event_set_days) { create(:event, days: [0, 1]) }
        it 'returns all the days as a string' do
          expect(event_set_days.days_as_string).to eq('Sun, Mon')
        end
      end

      context 'time_length' do
        it 'returns the hour length of event as a decimal' do
          expect(event.time_length).to eq(2.75)
        end
      end
    end
  end

  describe 'public class methods' do
    context 'responds to its methods' do
      it { expect(Event).to respond_to(:scoped_by_day) }
      it { expect(Event).to respond_to(:raw_sql) }
      it { expect(Event).to respond_to(:roles_conditions) }
    end

    context 'executes its methods correctly' do
      context 'scoped_by_day' do
        let!(:event) { create(:event, days: [0]) }
        let!(:role) { create(:role) }
        let!(:user) { create(:athlete_user) }
        it 'returns all the events on a particular day with a scope' do
          user.schedule = create(:schedule, event: [event])
          user.add_role role.name
          Scope.backfill_event_scope(user, role)
          expect(Event.scoped_by_day(0, [role.id]).first).to eq(event)
        end
        it 'returns all the events when role is nil' do
          event2 = create(:event, days: [0])
          user.schedule = create(:schedule, event: [event, event2])
          user.add_role role.name
          Scope.backfill_event_scope(user, role)
          expect(Event.scoped_by_day(0, '').count).to eq(Event.where('0=ANY(days)').count)
        end
      end

      context 'raw_sql' do
        it 'without roles gives the simple query' do
          correct_query = 'SELECT DISTINCT(events.*) FROM events '\
          'WHERE 0=ANY(events.days)'
          expect(Event.raw_sql(0, nil)).to eq(correct_query)
        end

        it 'when given roles it returns the full query' do
          role1 = create(:role)
          role2 = create(:role)
          correct_query = 'SELECT DISTINCT(events.*) FROM events'\
          " INNER JOIN (SELECT * FROM scopes WHERE scopes.role_id = #{role1.id}"\
          " OR scopes.role_id = #{role2.id} )  sub_scopes ON (sub_scopes.resource_id"\
          ' = events.id) WHERE 0=ANY(events.days)'
          expect(Event.raw_sql(0, [role1.id, role2.id])).to eq(correct_query)
        end
      end
    end
  end
end
