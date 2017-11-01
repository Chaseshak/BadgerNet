require 'rails_helper'

RSpec.feature 'Visiting the schedule page', type: :feature do
  before do
    visit 'schedule'
  end
  scenario 'it loads the schedule page' do
    expect(current_path).to eq('/schedule')
  end

  scenario 'it displays the calendar' do
    expect(page).to have_css('div.calendar-container')
  end
end

RSpec.feature 'Creating a new event', type: :feature do
  before do
    visit 'schedule'
  end

  scenario 'the new event button triggers the new event modal' do
    click_on 'New Event'
    expect(page.find('#new-event')).not_to have_css('hidden')
  end
end
