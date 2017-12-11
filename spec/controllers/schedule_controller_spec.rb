require 'rails_helper'
RSpec.describe ScheduleController, type: :controller do
  describe 'GET #index' do
    context 'as an un-authenticated user' do
      before do
        get :index
      end
      include_examples 'redirects as un-authenticated user'
    end

    context 'as an authenticated user' do
      before do
        coach = create(:athlete_user)
        sign_in(coach)
        get :index
      end
      include_examples 'renders the template', :index
    end
  end

  describe 'POST #create_event' do
    before do
      athlete = create(:athlete_user)
      sign_in(athlete)
      get :index
    end
    context 'given a valid event' do
      it 'creates an event' do
        expect do
          post :create_event, params: { name: 'My Event',
                                        time: { 'start' => '09:00', 'end' => '16:45' },
                                        days: [0, 2, 3] }
        end.to change { Event.count }.by(1)
      end
    end
  end

  describe 'DELETE #destroy_event' do
    before do
      athlete = create(:athlete_user)
      sign_in(athlete)
    end

    let(:event) { create(:event) }

    context 'given a valid event id' do
      it 'deletes the event' do
        delete :destroy_event, params: { event_id: event.id }
        expect { Event.find(event.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
