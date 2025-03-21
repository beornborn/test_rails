# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Responses', type: :request do
  before(:each) do
    Faker::UniqueGenerator.clear
  end

  let!(:user) { create(:user) }
  let(:survey) { create(:survey, options: ['Option 1', 'Option 2', 'Option 3']) }
  let(:headers) { { 'X-User-Uuid' => user.uuid } }

  describe 'authentication' do
    it 'returns unauthorized when no user UUID is provided' do
      post "/api/v1/surveys/#{survey.id}/responses"
      expect(response).to have_http_status(:unauthorized)
      expect(json_response).to eq('error' => 'Unauthorized')
    end

    it 'returns unauthorized when invalid user UUID is provided' do
      post "/api/v1/surveys/#{survey.id}/responses", headers: { 'X-User-Uuid' => 'invalid-uuid' }
      expect(response).to have_http_status(:unauthorized)
      expect(json_response).to eq('error' => 'Unauthorized')
    end
  end

  describe 'POST /api/v1/surveys/:survey_id/responses' do
    let(:valid_params) do
      {
        response: {
          answer: 'Option 1',
        },
      }
    end

    context 'with valid params' do
      it 'creates a new response' do
        expect do
          post "/api/v1/surveys/#{survey.id}/responses", params: valid_params, headers: headers
        end.to change(Response, :count).by(1)
      end

      it 'returns a created status' do
        post "/api/v1/surveys/#{survey.id}/responses", params: valid_params, headers: headers
        expect(response).to have_http_status(:created)
      end

      it 'associates the response with the current user' do
        post "/api/v1/surveys/#{survey.id}/responses", params: valid_params, headers: headers
        expect(Response.last.user_id).to eq(user.id)
      end

      it 'associates the response with the survey' do
        post "/api/v1/surveys/#{survey.id}/responses", params: valid_params, headers: headers
        expect(Response.last.survey_id).to eq(survey.id)
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        {
          response: {
            answer: 'Invalid Option',
          },
        }
      end

      it 'does not create a new response' do
        expect do
          post "/api/v1/surveys/#{survey.id}/responses", params: invalid_params, headers: headers
        end.not_to change(Response, :count)
      end

      it 'returns an unprocessable entity status' do
        post "/api/v1/surveys/#{survey.id}/responses", params: invalid_params, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messages' do
        post "/api/v1/surveys/#{survey.id}/responses", params: invalid_params, headers: headers
        expect(json_response).to have_key('errors')
      end
    end

    context 'when user has already responded to the survey' do
      before do
        create(:response, survey: survey, user: user, answer: 'Option 1')
      end

      it 'does not create a new response' do
        expect do
          post "/api/v1/surveys/#{survey.id}/responses", params: valid_params, headers: headers
        end.not_to change(Response, :count)
      end

      it 'returns an unprocessable entity status' do
        post "/api/v1/surveys/#{survey.id}/responses", params: valid_params, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /api/v1/surveys/:survey_id/responses/own' do
    context 'when user has a response for the survey' do
      let!(:user_response) { create(:response, survey: survey, user: user) }

      it 'deletes the response' do
        expect do
          delete "/api/v1/surveys/#{survey.id}/responses/own", headers: headers
        end.to change(Response, :count).by(-1)
      end

      it 'returns a successful response' do
        delete "/api/v1/surveys/#{survey.id}/responses/own", headers: headers
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user does not have a response for the survey' do
      it 'returns a not found status' do
        delete "/api/v1/surveys/#{survey.id}/responses/own", headers: headers
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
