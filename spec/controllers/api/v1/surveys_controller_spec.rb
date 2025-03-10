# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SurveysController, type: :controller do
  before(:each) do
    Faker::UniqueGenerator.clear
  end

  let(:user) { create(:user) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    let!(:survey1) { create(:survey) }
    let!(:survey2) { create(:survey) }
    let!(:survey3) { create(:survey) }

    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'returns all surveys' do
      get :index
      expect(json_response.size).to eq(3)
    end
  end

  describe 'GET #show' do
    let(:survey) { create(:survey) }

    it 'returns a successful response' do
      get :show, params: { id: survey.id }
      expect(response).to have_http_status(:ok)
    end

    it 'returns the requested survey' do
      get :show, params: { id: survey.id }
      expect(json_response['id']).to eq(survey.id)
    end
  end

  describe 'POST #create' do
    let(:valid_params) do
      {
        survey: {
          question: 'What is your favorite color?',
          options: ['Red', 'Blue', 'Green']
        }
      }
    end

    context 'with valid params' do
      it 'creates a new survey' do
        expect {
          post :create, params: valid_params
        }.to change(Survey, :count).by(1)
      end

      it 'returns a created status' do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)
      end

      it 'associates the survey with the current user' do
        post :create, params: valid_params
        expect(Survey.last.user).to eq(user)
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        {
          survey: {
            question: '',
            options: []
          }
        }
      end

      it 'does not create a new survey' do
        expect {
          post :create, params: invalid_params
        }.not_to change(Survey, :count)
      end

      it 'returns an unprocessable entity status' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messages' do
        post :create, params: invalid_params
        expect(json_response).to have_key('errors')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user owns the survey' do
      let!(:survey) { create(:survey, user: user) }

      it 'deletes the survey' do
        expect {
          delete :destroy, params: { id: survey.id }
        }.to change(Survey, :count).by(-1)
      end

      it 'returns a successful response' do
        delete :destroy, params: { id: survey.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user does not own the survey' do
      let!(:survey) { create(:survey) }

      it 'does not delete the survey' do
        expect {
          delete :destroy, params: { id: survey.id }
        }.not_to change(Survey, :count)
      end

      it 'returns a forbidden status' do
        delete :destroy, params: { id: survey.id }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
