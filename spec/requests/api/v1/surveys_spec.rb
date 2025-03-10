# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Surveys', type: :request do
  before(:each) do
    Faker::UniqueGenerator.clear
  end

  let!(:user) { create(:user) }
  let(:headers) { { 'X-User-Uuid' => user.uuid } }

  describe 'authentication' do
    it 'returns unauthorized when no user UUID is provided' do
      get '/api/v1/surveys'
      expect(response).to have_http_status(:unauthorized)
      expect(json_response).to eq('error' => 'Unauthorized')
    end

    it 'returns unauthorized when invalid user UUID is provided' do
      get '/api/v1/surveys', headers: { 'X-User-Uuid' => 'invalid-uuid' }
      expect(response).to have_http_status(:unauthorized)
      expect(json_response).to eq('error' => 'Unauthorized')
    end
  end

  describe 'GET /api/v1/surveys' do
    let!(:survey1) { create(:survey) }
    let!(:survey2) { create(:survey) }
    let!(:survey3) { create(:survey) }

    it 'returns a successful response' do
      get '/api/v1/surveys', headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'returns all surveys' do
      get '/api/v1/surveys', headers: headers
      expect(json_response.size).to eq(3)
    end
  end

  describe 'GET /api/v1/surveys/:id' do
    let(:survey) { create(:survey) }

    it 'returns a successful response' do
      get "/api/v1/surveys/#{survey.id}", headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'returns the requested survey' do
      get "/api/v1/surveys/#{survey.id}", headers: headers
      expect(json_response['id']).to eq(survey.id)
    end
  end

  describe 'POST /api/v1/surveys' do
    let(:valid_params) do
      {
        survey: {
          question: 'What is your favorite color?',
          options: ['Red', 'Blue', 'Green'],
        },
      }
    end

    context 'with valid params' do
      it 'creates a new survey' do
        expect do
          post '/api/v1/surveys', params: valid_params, headers: headers
        end.to change(Survey, :count).by(1)
      end

      it 'returns a created status' do
        post '/api/v1/surveys', params: valid_params, headers: headers
        expect(response).to have_http_status(:created)
      end

      it 'associates the survey with the current user' do
        post '/api/v1/surveys', params: valid_params, headers: headers
        expect(Survey.last.user_id).to eq(user.id)
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        {
          survey: {
            question: '',
            options: [],
          },
        }
      end

      it 'does not create a new survey' do
        expect do
          post '/api/v1/surveys', params: invalid_params, headers: headers
        end.not_to change(Survey, :count)
      end

      it 'returns an unprocessable entity status' do
        post '/api/v1/surveys', params: invalid_params, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messages' do
        post '/api/v1/surveys', params: invalid_params, headers: headers
        expect(json_response).to have_key('errors')
      end
    end
  end

  describe 'DELETE /api/v1/surveys/:id' do
    context 'when user owns the survey' do
      let!(:survey) { create(:survey, user: user) }

      it 'deletes the survey' do
        expect do
          delete "/api/v1/surveys/#{survey.id}", headers: headers
        end.to change(Survey, :count).by(-1)
      end

      it 'returns a successful response' do
        delete "/api/v1/surveys/#{survey.id}", headers: headers
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user does not own the survey' do
      let!(:survey) { create(:survey) }

      it 'does not delete the survey' do
        expect do
          delete "/api/v1/surveys/#{survey.id}", headers: headers
        end.not_to change(Survey, :count)
      end

      it 'returns a forbidden status' do
        delete "/api/v1/surveys/#{survey.id}", headers: headers
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
