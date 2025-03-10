# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    uuid { SecureRandom.uuid }
  end
end
