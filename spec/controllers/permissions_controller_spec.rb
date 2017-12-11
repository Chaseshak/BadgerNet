require 'rails_helper'

RSpec.describe PermissionsController, type: :controller do
  describe 'GET #index' do
    context 'User is not signed in' do
      before do
        get :index
      end
      include_examples 'redirects as un-authenticated user'
    end

    context 'User does not have the :coach role' do
      before do
        athlete = create(:athlete_user)
        sign_in(athlete)
      end
      it 'returns http forbidden' do
        get :index
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'User has the :coach role' do
      before do
        coach = create(:coach_user)
        sign_in(coach)
        get :index
      end

      include_examples 'renders the template', :index

      context 'There are existing users in the database' do
        it 'assigns @users' do
          expect(assigns(:users)).not_to be_nil
        end
      end
    end
  end

  describe 'POST #create' do
    before do
      coach_adding = create(:coach_user)
      sign_in(coach_adding)
    end

    context 'with invalid parameters' do
      it 'returns an error for a blank email address' do
        post :create, params: { email: '', role: :athlete }
        expect(flash[:danger]).to eq('Error: Email cannot be blank.')
      end

      it 'returns an error for an email in the wrong domain' do
        post :create, params: { email: 'test@gmail.com', role: :athlete }
        expect(flash[:danger]).to eq('Error: Email must '\
        'be a valid @wisc.edu email address.')
      end
    end

    context 'creating a new athlete user' do
      it 'adds a new athlete user to the database and displays success message' do
        expect do
          post :create, params: { email: 'invited_athlete@wisc.edu', role: :athlete }
        end.to change { (User.with_role :athlete).count }.by(1)
        expect(flash[:success]).to eq('Successfully '\
          'sent an invite to invited_athlete@wisc.edu!')
      end
    end

    context 'creating a new coach user' do
      it 'adds a new coach user to the database and displays success message' do
        expect do
          post :create, params: { email: 'invited_coach@wisc.edu', role: :coach }
        end.to change { (User.with_role :coach).count }.by(1)
        expect(flash[:success]).to eq('Successfully '\
          'sent an invite to invited_coach@wisc.edu!')
      end
    end

    context 'inviting a user that already exists' do
      it 'does not invite the user again' do
        post :create, params: { email: 'inv@wisc.edu', role: :athlete }
        expect do
          post :create, params: { email: 'inv@wisc.edu', role: :athlete }
        end.not_to(change { User.count })
        expect(flash[:notice]).to eq('User inv@wisc.edu already exists! Invite not sent.')
      end
    end
  end

  describe 'PUT #update' do
    before do
      coach_modifying = create(:coach_user)
      sign_in(coach_modifying)
    end
    context 'given a coach user' do
      it 'downgrades their permission level to an athlete user' do
        to_modify = create(:coach_user)
        put :update, params: { id: to_modify.id }
        expect(to_modify.has_role?(:coach)).to be false
        expect(to_modify.has_role?(:athlete)).to be true
        success_message = "Successfully changed #{to_modify.email}'s permission level"
        expect(flash[:success]).to eq(success_message)
      end
    end

    context 'given an athlete user' do
      it 'upgrades their permission level to a coach user' do
        to_modify = create(:athlete_user)
        put :update, params: { id: to_modify.id }
        expect(to_modify.has_role?(:athlete)).to be false
        expect(to_modify.has_role?(:coach)). to be true
        success_message = "Successfully changed #{to_modify.email}'s permission level"
        expect(flash[:success]).to eq(success_message)
      end
    end

    context 'given bad params' do
      it 'returns the error message' do
        put :update, params: { id: -1 }
        expect(flash[:danger]).to eq('Unable to update user at this time.')
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      coach = create(:coach_user)
      sign_in(coach)
    end

    context 'existing user' do
      let!(:u) { create(:athlete_user) }

      it 'should redirect' do
        delete :destroy, params: { id: u.id }
        expect(response.status).to eq(302)
      end

      it 'should remove the user' do
        expect { delete :destroy, params: { id: u.id } }.to change { User.count }.by(-1)
      end
    end

    context 'delete a non-existing user' do
      it 'creates an error message' do
        delete :destroy, params: { id: 1000 }
        expect(flash[:alert]).to include('Could not find specified user')
      end
    end
  end
end
