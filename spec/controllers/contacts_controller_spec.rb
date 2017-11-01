require 'rails_helper'

RSpec.describe ContactsController, type: :controller do
  describe 'GET #index' do
    before do
      get :index
    end
    it 'responds with a 200 status' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end

    it 'assigns @users' do
      expect(assigns(:users)).not_to be_nil
    end
  end
end
