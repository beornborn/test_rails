# frozen_string_literal: true

class User < ApplicationRecord
  validates :uuid, presence: true, uniqueness: true

  has_many :responses
  has_many :surveys, through: :responses
end
