# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeleteSurveyService do
  # Reset Faker::Lorem.unique before each test
  before(:each) do
    Faker::UniqueGenerator.clear
  end

  describe '.call' do
    let(:user) { create(:user) }
    let!(:survey) { create(:survey, user: user) }

    context 'when survey has no responses' do
      it 'deletes the survey' do
        expect {
          described_class.call(survey)
        }.to change { Survey.count }.by(-1)
      end

      it 'returns true' do
        expect(described_class.call(survey)).to be true
      end
    end

    context 'when survey has responses' do
      let!(:response1) { create(:response, survey: survey, user: create(:user)) }
      let!(:response2) { create(:response, survey: survey, user: create(:user)) }

      it 'deletes the survey' do
        expect {
          described_class.call(survey)
        }.to change { Survey.count }.by(-1)
      end

      it 'soft deletes all responses' do
        expect {
          described_class.call(survey)
        }.to change { Response.count }.by(-2)
          .and change { Response.with_deleted.count }.by(0)
      end

      it 'returns true' do
        expect(described_class.call(survey)).to be true
      end
    end

    context 'when an error occurs' do
      before do
        allow_any_instance_of(Survey).to receive(:destroy).and_raise(StandardError.new("Test error"))
      end

      it 'returns false' do
        expect(described_class.call(survey)).to be false
      end

      it 'does not delete the survey' do
        expect {
          described_class.call(survey)
        }.not_to change { Survey.count }
      end
    end
  end
end
