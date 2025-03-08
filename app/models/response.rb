# frozen_string_literal: true

class Response < ApplicationRecord
  acts_as_paranoid

  belongs_to :survey
  belongs_to :user

  validates :answer, presence: true
  validates :user_id, uniqueness: { scope: :survey_id, message: 'has already responded to this survey' }
  validate :validate_answer_in_options

  private

  def validate_answer_in_options
    return if answer.blank? || survey.nil?

    unless survey.options.include?(answer)
      errors.add(:answer, 'must be one of the available options')
    end
  end
end
