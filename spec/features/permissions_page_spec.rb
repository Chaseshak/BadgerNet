require 'rails_helper'

RSpec.feature 'Visiting the permissions page', type: :feature do
  scenario 'As an un-authenticated user, loads the login page' do
    visit 'permissions'
    expect(current_path).to eq('/users/sign_in')
  end

  scenario 'As a user with the athlete role, there should be a 403 status code' do
    login_athlete
    visit 'permissions'
    expect(page.status_code).to eq(403)
  end

  context 'As an authenticated user with the coach role' do
    before do
      login_coach
      FactoryGirl.create(:athlete_user, email: 'test@example.com')
      visit 'permissions'
    end
    scenario 'There should be a 200 status code' do
      expect(page.status_code).to eq(200)
      expect(current_path).to eq('/permissions')
    end

    scenario 'There should be an accurate athlete user in the table of information' do
      expect(page).to have_content('test@example.com')
      expect(page).to have_content('John')
      expect(page).to have_content('Smith')
      expect(page).to have_content(/athlete/i)
    end

    scenario 'Deleting a user should remove their information from the table' do
      FactoryGirl.create(:athlete_user, email: 'test1@example.com')
      expect { page.all('input', class: 'button-danger')[0].click }
        .to change { User.count }.by(-1)
    end

    scenario 'There should be a button to invite a new user which opens a modal' do
      expect(page).to have_content('Invite New User')
      click_on 'Invite New User'
      expect(page.find('#new-user')).not_to have_css('hidden')
    end

    scenario 'Inviting a new user should result in a pending invite' do
      click_on 'Invite New User'
      fill_in('email', with: 'invited@wisc.edu')
      click_on 'Invite User'
      expect(page).to have_content('Pending Invite')
      expect(page).to have_content('Successfully sent an invite to invited@wisc.edu!')
    end
  end
end
