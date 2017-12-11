require 'rails_helper'

RSpec.describe Schedule, type: :model do
  it 'has a valid factory' do
    expect(build(:schedule)).to be_valid
  end

  let(:schedule) { create(:schedule) }

  describe 'ActiveRecord Associations' do
    it { expect(schedule).to belong_to(:user) }
    it { expect(schedule).to have_many(:event) }
  end

  describe 'public instance methods' do
    context 'responds to its methods' do
      it { expect(schedule).to respond_to(:events_on_day) }
    end

    context 'executes methods correctly' do
      context 'events_on_day' do
        it 'returns the correct events on a day for the schedule' do
          schedule.event.each do |event|
            event.days.each do |day_num|
              expect(schedule.events_on_day(day_num)).to include(event)
            end
          end
        end
      end
    end
  end
end
