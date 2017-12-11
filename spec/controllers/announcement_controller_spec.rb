require 'rails_helper'

RSpec.describe AnnouncementController, type: :controller do
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
      it 'returns http ok' do
        get :index
        expect(response).to have_http_status(:ok)
      end
    end

    context 'User has the :coach role' do
      before do
        coach = create(:coach_user)
        sign_in(coach)
        get :index
      end
      include_examples 'renders the template', :admin_index
    end
  end

  describe 'GET #new' do
    context 'user is a coach user' do
      it 'assigns the @announcement variable' do
        controller.new
        expect(assigns(:announcement).to_json).to eq(Announcement.new.to_json)
      end
    end
  end

  describe 'POST #create' do
    before do
      coach = create(:coach_user)
      sign_in(coach)
    end
    context 'given a valid announcement' do
      let(:a) { build(:announcement_email) }
      role = [Role.create(name: 'test').id]
      it 'creates an announcement' do
        expect do
          post :create, params: { announcement: { email: a.email, sms: a.sms,
                                                  title: a.title, content: a.content },
                                  roles:  role }
        end.to change { Announcement.count }.by(1)
      end
    end
    context 'creating an announcement as a text message' do
      let(:a) { build(:announcement_sms) }
      it 'sends a text message' do
        # Stub the send text message function to make it a dummy method
        allow_any_instance_of(AnnouncementController).to receive(:send_text_message)
        expect do
          post :create, params: { announcement: { email: a.email, sms: a.sms,
                                                  title: a.title, content: a.content } }
        end.to change { Announcement.count }.by(1)
      end
    end
    context 'with an invalid announcement' do
      let(:a) do
        # Build an invalid announcement (i.e. false email and sms)
        invalid_a = build(:announcement_sms, email: false, sms: false)
        # Tell active record not to validate the announcement object
        invalid_a.save(validate: false)
        invalid_a # return value which is stored in the variable 'a'.
      end
      it 'redirects and gives an error message to the user' do
        role = [Role.create(name: 'test').id]
        post :create, params: { announcement: { email: a.email, sms: a.sms,
                                                title: a.title, content: a.content },
                                roles: role }
        expect(flash[:alert]).to include(
          'Please select a send type before submitting announcement'
        )
        expect(response.status).to eq(302)
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      coach = create(:coach_user)
      sign_in(coach)
    end

    context 'existing announcement' do
      let!(:a) { FactoryGirl.create(:announcement_email) }

      it 'should redirect' do
        delete :destroy, params: { id: a.id }
        expect(response.status).to eq(302)
      end

      it 'should remove the announcement' do
        expect { delete :destroy, params: { id: a.id } }.to change { Announcement.count }
          .by(-1)
      end
    end

    context 'delete a non-existing announcement' do
      it 'creates an error message' do
        delete :destroy, params: { id: 1000 }
        expect(flash[:alert]).to include('Could not find this announcement')
      end
    end
  end

  describe 'GET #show' do
    before do
      coach = create(:coach_user)
      sign_in(coach)
    end

    context 'an existing announcement' do
      let!(:a) { FactoryGirl.create(:announcement_email) }

      it 'assigns the requested announcement to @ann' do
        get :show, params: { id: a.id }
        expect(assigns(:announcement)).to eq(a)
      end
    end

    context 'a non-existing announcement' do
      it 'creates an error message' do
        get :show, params: { id: 1000 }
        expect(flash[:alert]).to include('Could not find this announcement')
      end
    end
  end
end
