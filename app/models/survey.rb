# frozen_string_literal: true

class Survey < ApplicationRecord
  acts_as_paranoid

  validates :question, presence: true

  has_many :responses
  has_many :users, through: :responses
  belongs_to :user

  def response_counts
    responses.group(:answer).count
  end

  def user_responded?(user:)
    return false if user.nil?

    responses.exists?(user: user)
  end

  def graceful_destroy
    SurveyService.delete_survey(self)
  end
end
