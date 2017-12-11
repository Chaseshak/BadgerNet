require 'rails_helper'

RSpec.feature 'Visiting the contacts page', type: :feature do
  context 'as an authenticated user' do
    scenario 'it loads the contacts page' do
      login_athlete
      visit 'contacts'
      expect(current_path).to eq('/contacts')
    end

    context 'when users have been populated in the database' do
      before do
        login_athlete
        5.times do
          create(:athlete_user, first_name: 'Josh', last_name: 'Brown',
                                phone: '0987654321')
        end
        visit 'contacts'
      end

      scenario 'all users displayed in table with the approrpriate fields' do
        expect(page).to have_text('Josh', count: 5)
        expect(page).to have_text('Brown', count: 5)
        expect(page).to have_text('0987654321', count: 5)
      end
    end
  end
end
