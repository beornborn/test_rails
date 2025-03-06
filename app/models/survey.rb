# frozen_string_literal: true

class Survey < ApplicationRecord
  validates :question, presence: true

  has_many :responses
  has_many :users, through: :responses
end
