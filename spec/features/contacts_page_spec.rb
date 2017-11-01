require 'rails_helper'

RSpec.feature 'Visiting the contacts page', type: :feature do
  scenario 'it loads the contacts page' do
    visit 'contacts'
    expect(current_path).to eq('/contacts')
  end

  context 'when users have been populated in the database' do
    before do
      5.times { create(:athlete_user) }
      visit 'contacts'
    end

    scenario 'all users displayed in table with the approrpriate fields' do
      expect(page).to have_text('john', count: 5)
      expect(page).to have_text('smith', count: 5)
      expect(page).to have_text('@test.com', count: 5)
      expect(page).to have_text('1234567890', count: 5)
    end
  end
end
