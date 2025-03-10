# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ResponsesController, type: :controller do
  # Reset Faker::Lorem.unique before each test
  before(:each) do
    Faker::UniqueGenerator.clear
  end

  let(:user) { create(:user) }
  let(:survey) { create(:survey, options: ['Option 1', 'Option 2', 'Option 3']) }

  before do
    # Make sure we're using the same user instance throughout the test
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'POST #create' do
    let(:valid_params) do
      {
        survey_id: survey.id,
        response: {
          answer: 'Option 1'
        }
      }
    end

    context 'with valid params' do
      it 'creates a new response' do
        expect {
          post :create, params: valid_params
        }.to change(Response, :count).by(1)
      end

      it 'returns a created status' do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)
      end

      it 'associates the response with the current user' do
        post :create, params: valid_params
        expect(Response.last.user).to eq(user)
      end

      it 'associates the response with the survey' do
        post :create, params: valid_params
        expect(Response.last.survey).to eq(survey)
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        {
          survey_id: survey.id,
          response: {
            answer: 'Invalid Option'
          }
        }
      end

      it 'does not create a new response' do
        expect {
          post :create, params: invalid_params
        }.not_to change(Response, :count)
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

    context 'when user has already responded to the survey' do
      before do
        create(:response, survey: survey, user: user, answer: 'Option 1')
      end

      it 'does not create a new response' do
        expect {
          post :create, params: valid_params
        }.not_to change(Response, :count)
      end

      it 'returns an unprocessable entity status' do
        post :create, params: valid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #own' do
    context 'when user has a response for the survey' do
      let!(:user_response) { create(:response, survey: survey, user: user) }

      it 'deletes the response' do
        expect {
          delete :own, params: { survey_id: survey.id }
        }.to change(Response, :count).by(-1)
      end

      it 'returns a successful response' do
        delete :own, params: { survey_id: survey.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user does not have a response for the survey' do
      it 'raises a record not found error' do
        expect {
          delete :own, params: { survey_id: survey.id }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
