# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::BaseController, type: :controller do
  before(:each) do
    User.destroy_all
  end

  controller(Api::BaseController) do
    def index
      render json: { user_id: current_user.id }
    end
  end

  describe '#current_user' do
    context 'when X-User-UUID header is present' do
      let!(:user) { create(:user) }

      before do
        request.headers['X-User-UUID'] = user.uuid
      end

      it 'returns the user with the matching UUID' do
        get :index
        expect(response).to have_http_status(:ok)
        expect(json_response['user_id']).to eq(user.id)
      end
    end

    context 'when X-User-UUID header is not present' do
      it 'creates a new user' do
        expect {
          get :index
        }.to change(User, :count).by(1)
      end

      it 'returns a successful response' do
        get :index
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when X-User-UUID header is present but user does not exist' do
      let(:non_existent_uuid) { 'non-existent-uuid' }

      before do
        request.headers['X-User-UUID'] = non_existent_uuid
      end

      it 'creates a new user with the provided UUID' do
        expect {
          get :index
        }.to change(User, :count).by(1)

        # Directly query for the user with this UUID instead of assuming it's the last one
        user = User.find_by(uuid: non_existent_uuid)
        expect(user).not_to be_nil
        expect(user.uuid).to eq(non_existent_uuid)
      end
    end
  end
end
