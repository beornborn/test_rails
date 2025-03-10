# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Response, type: :model do
  describe 'answer validation' do
    let(:survey) { create(:survey, options: ['Option 1', 'Option 2']) }
    let(:user) { create(:user) }

    it 'validates that answer is one of the survey options' do
      response = build(:response, survey: survey, user: user, answer: 'Invalid Option')
      expect(response).not_to be_valid
      expect(response.errors[:answer]).to include('must be one of the available options')
    end

    it 'is valid when answer is one of the survey options' do
      response = build(:response, survey: survey, user: user, answer: 'Option 1')
      expect(response).to be_valid
    end
  end
end
