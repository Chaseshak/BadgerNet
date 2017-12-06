require 'rails_helper'

RSpec.describe SettingsController, type: :controller do
  describe 'GET #index' do
    context 'User is not signed in' do
      before do
        get :index
      end
      include_examples 'redirects as un-authenticated user'
    end

    context 'User is signed in' do
      before do
        athlete = create(:athlete_user)
        sign_in(athlete)
        get :index
      end

      it 'assigns the @user variable' do
        expect(assigns(:user)).not_to be_nil
      end

      include_examples 'renders the template', :index
    end
  end

  describe 'PUT #update' do
    context 'User updates no settings' do
      it 'user profile information does not change' do
        user = create(:athlete_user)
        sign_in(user)
        user_before = user
        put :update, params: { id: user.id, user: attributes_for(:user) }
        expect(user).to eq(user_before)
      end
    end

    context 'user updates one setting' do
      it 'updates the user setting' do
        user = create(:athlete_user)
        sign_in(user)
        put :update, params: { id: user.id, user: { first_name: 'test' } }
        user = User.find(user.id) # reload
        expect(flash[:success]).to eq('User Profile Sucessfully Updated')
        expect(user.first_name).to eq('Test')
      end
    end

    context 'user updates multiple settings' do
      it 'updates all the settings' do
        user = create(:athlete_user)
        sign_in(user)
        new_settings = { first_name: 'test', phone: '0987654321' }
        put :update, params: { id: user.id, user: new_settings }
        user = User.find(user.id) # reload
        expect(flash[:success]).to eq('User Profile Sucessfully Updated')
        expect(user.first_name).to eq('Test')
        expect(user.phone).to eq('0987654321')
      end
    end

    context 'user provides an invalid value for a field' do
      it 'returns the validation error and does not update user' do
        user = create(:athlete_user)
        sign_in(user)
        new_settings = { first_name: '', phone: '1' }
        put :update, params: { id: user.id, user: new_settings }
        user_after = User.find(user.id) # reload
        error = "Validation failed: First name can't be blank, Phone Please enter a 10 "\
        'digit US Phone Number'
        expect(flash[:danger]).to eq(error)
        expect(user).to eq(user_after)
      end
    end
  end
end
