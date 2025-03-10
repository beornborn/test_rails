# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchSurveysService do
  # Reset Faker::Lorem.unique before each test
  before(:each) do
    Faker::UniqueGenerator.clear
  end

  describe '.call' do
    let!(:survey1) { create(:survey, created_at: 1.day.ago) }
    let!(:survey2) { create(:survey, created_at: 2.days.ago) }
    let!(:survey3) { create(:survey, created_at: Time.current) }

    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }

    before do
      create(:response, survey: survey1, user: user1, answer: survey1.options[0])
      create(:response, survey: survey1, user: user2, answer: survey1.options[1])
      create(:response, survey: survey2, user: user1, answer: survey2.options[0])
    end

    it 'returns surveys ordered by created_at desc' do
      surveys = described_class.call
      expect(surveys.to_a).to eq([survey3, survey1, survey2])
    end

    it 'precomputes response counts for each survey' do
      surveys = described_class.call

      expect(surveys.first.response_counts).to eq({})
      expect(surveys.second.response_counts).to eq({
        survey1.options[0] => 1,
        survey1.options[1] => 1
      })
      expect(surveys.third.response_counts).to eq({
        survey2.options[0] => 1
      })
    end
  end
end
