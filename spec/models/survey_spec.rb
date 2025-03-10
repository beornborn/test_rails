# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Survey, type: :model do
  describe 'options validation' do
    let(:user) { create(:user) }

    it 'requires at least 2 options' do
      survey = build(:survey, options: ['Option 1'], user: user)
      expect(survey).not_to be_valid
      expect(survey.errors[:options]).to include('must have at least 2 options')
    end

    it 'requires unique options' do
      survey = build(:survey, options: ['Option 1', 'Option 1'], user: user)
      expect(survey).not_to be_valid
      expect(survey.errors[:options]).to include('must be unique')
    end

    it 'rejects empty options' do
      survey = build(:survey, options: ['Option 1', ''], user: user)
      expect(survey).not_to be_valid
      expect(survey.errors[:options]).to include('cannot contain empty values')
    end
  end

  describe '#response_counts' do
    let(:survey) { create(:survey) }
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    before do
      create(:response, survey: survey, user: user1, answer: survey.options[0])
      create(:response, survey: survey, user: user2, answer: survey.options[0])
    end

    it 'returns a hash of answer counts' do
      expect(survey.response_counts).to eq({ survey.options[0] => 2 })
    end
  end

  describe '#user_responded?' do
    let(:survey) { create(:survey) }
    let(:user) { create(:user) }

    context 'when user has responded' do
      before do
        create(:response, survey: survey, user: user)
      end

      it 'returns true' do
        expect(survey.user_responded?(response_user_id: user.id)).to be true
      end
    end

    context 'when user has not responded' do
      it 'returns false' do
        expect(survey.user_responded?(response_user_id: user.id)).to be false
      end
    end

    context 'when user_id is nil' do
      it 'returns false' do
        expect(survey.user_responded?(response_user_id: nil)).to be false
      end
    end
  end
end
