# frozen_string_literal: true

class Response < ApplicationRecord
  belongs_to :survey
  belongs_to :user

  validates :answer, presence: true
  validates :answer, inclusion: { in: %w[yes no], message: "must be either 'yes' or 'no'" }
end
