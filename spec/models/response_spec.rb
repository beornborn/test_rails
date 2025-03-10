# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Response, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:answer) }

    describe 'uniqueness validation' do
      subject { build(:response) }
      it { should validate_uniqueness_of(:user_id).scoped_to(:survey_id).with_message('has already responded to this survey') }
    end
  end

  describe 'associations' do
    it { should belong_to(:survey) }
    it { should belong_to(:user) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:response)).to be_valid
    end
  end

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
