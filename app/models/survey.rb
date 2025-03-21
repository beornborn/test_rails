# frozen_string_literal: true

class Survey < ApplicationRecord
  acts_as_paranoid

  attr_writer :response_counts

  validates :question, presence: true
  validates :options, presence: true
  validate :validate_options

  has_many :responses
  has_many :users, through: :responses
  belongs_to :user

  def response_counts
    @response_counts ||= responses.group(:answer).count
  end

  def user_responded?(response_user_id:)
    return false if response_user_id.nil?

    if responses.loaded?
      responses.any? { |response| response.user_id == response_user_id }
    else
      responses.exists?(user_id: response_user_id)
    end
  end

  def graceful_destroy
    success = ::DeleteSurveyService.call(self)
    errors.add(:base, 'Failed to delete survey') unless success
    success
  end

  private

  def validate_options
    return if options.blank?

    unless options.is_a?(Array)
      errors.add(:options, 'must be an array')
      return
    end

    if options.length < 2
      errors.add(:options, 'must have at least 2 options')
      return
    end

    if options.any?(&:blank?)
      errors.add(:options, 'cannot contain empty values')
      return
    end

    if options.uniq.length != options.length
      errors.add(:options, 'must be unique')
    end
  end
end
