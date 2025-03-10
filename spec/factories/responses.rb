# frozen_string_literal: true

FactoryBot.define do
  factory :response do
    association :survey
    association :user
    answer { survey.options.sample }
  end
end
