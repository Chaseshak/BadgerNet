require 'rails_helper'

RSpec.describe ContactsController, type: :controller do
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
        get :index
      end

      include_examples 'renders the template', :index

      it 'assigns the @users variable' do
        expect(assigns(:users)).not_to be_nil
      end
    end

    context 'User has the :coach role' do
      before do
        coach = create(:coach_user)
        sign_in(coach)
        get :index
      end

      include_examples 'renders the template', :admin_index

      it 'assigns the variables' do
        expect(assigns(:users)).not_to be_nil
        expect(assigns(:roles)).not_to be_nil
      end
    end
  end

  describe 'POST #create' do
    before do
      coach = create(:coach_user)
      sign_in(coach)
    end

    it 'shows an alert if the team already exists (and is not archived)' do
      role = create(:role)
      post :create, params: { name: role.name }
      expect(flash[:alert]).to eq("Team '#{role.name}' already exists!")
    end

    it 'creates a new role (team) if one does not already exist' do
      post :create, params: { name: 'new_team' }
      expect(Role.where(name: 'new_team').first).not_to be nil
      expect(flash[:success]).to eq("Successfully added new team 'new_team'")
    end

    it 'un-archives role if already exists' do
      role = create(:role, archived: true)
      post :create, params: { name: role.name }
      expect(Role.find(role.id).archived).to be false
      expect(flash[:success]).to eq("Successfully added new team '#{role.name}'")
    end
  end

  describe 'PUT #update' do
    before do
      coach = create(:coach_user)
      sign_in(coach)
    end

    let(:user) { create(:athlete_user) }
    let(:role) { create(:role) }

    it 'adds the team if the user is not already on the team' do
      put :update, params: { id: user.id, role: role.id }
      expect(user.has_role?(role.name)).to be true
      success_message = "Successfully added #{user.first_name} to "\
      "#{role.name.capitalize} team!"
      expect(flash[:success]).to eq(success_message)
    end

    it 'removes the team if the user is already in the team' do
      user.add_role(role.name)
      put :update, params: { id: user.id, role: role.id }
      expect(user.has_role?(role.name)).to be false
      success_message = "Successfully removed #{user.first_name} from "\
      "#{role.name.capitalize} team!"
      expect(flash[:success]).to eq(success_message)
    end
  end

  describe 'DELETE #destroy' do
    before do
      coach = create(:coach_user)
      sign_in(coach)
    end

    it 'archives the teams when the teams ids' do
      role1 = create(:role)
      role2 = create(:role)
      delete :destroy, params: { roles: [role1.id, role2.id] }
      # Count is one because the coach_user has a role
      expect(Role.where(archived: false).count).to eq(1)
      success_message = "Successfully removed team(s): #{role1.name}, #{role2.name}"
      expect(flash[:success]).to eq(success_message)
    end

    it 'gives an error message when invalid roles passed' do
      create(:role)
      delete :destroy, params: { roles: nil }
      # Count is two because there is the coach role and the one we created
      expect(Role.where(archived: false).count).to eq(2)
      alert_message = 'Must select at least one team to delete!'
      expect(flash[:alert]).to eq(alert_message)
    end
  end
end
