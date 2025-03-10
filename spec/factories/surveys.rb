# frozen_string_literal: true

FactoryBot.define do
  factory :survey do
    question { Faker::Lorem.question }
    options { [Faker::Lorem.unique.word, Faker::Lorem.unique.word, Faker::Lorem.unique.word] }
    association :user
  end
end
