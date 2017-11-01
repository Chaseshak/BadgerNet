require 'rails_helper'

RSpec.describe AnnouncementController, type: :controller do
  describe 'GET #index' do
    context 'User is not signed in' do
      it 'redirects the user to the sign in page' do
        get :index
        expect(response).to redirect_to '/users/sign_in'
      end
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

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET #new' do
    context 'User does not have the :coach role' do
      before do
        athlete = create(:athlete_user)
        sign_in(athlete)
      end
      it 'returns http forbidden' do
        get :new
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'User has the :coach role' do
      before do
        coach = create(:coach_user)
        sign_in(coach)
        get :new
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'POST #create' do
    before do
      coach = create(:coach_user)
      sign_in(coach)
    end
    context 'given a valid announcment' do
      let(:a) { build(:announcement_email) }
      it 'creates an annoucement' do
        expect do
          post :create, params: { announcement: { email: a.email, sms: a.sms,
                                                  title: a.title, content: a.content } }
        end.to change { Announcement.count }.by(1)
      end
    end
    context 'creating an announcment as a text message' do
      let(:a) { build(:announcement_sms) }
      it 'sends a text message' do
        # Stub the send text message function to make it a dummy method
        allow_any_instance_of(AnnouncementHelper).to receive(:send_text_message)
        expect do
          post :create, params: { announcement: { email: a.email, sms: a.sms,
                                                  title: a.title, content: a.content } }
        end.to change { Announcement.count }.by(1)
      end
    end
  end
end
