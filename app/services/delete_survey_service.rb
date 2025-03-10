# frozen_string_literal: true

class DeleteSurveyService
  attr_reader :survey

  class << self
    def call(survey)
      new(survey).call
    end
  end

  def initialize(survey)
    @survey = survey
  end

  def call
    ActiveRecord::Base.transaction do
      delete_responses
      survey.destroy
    end
    true
  rescue StandardError
    false
  end

  private

  def delete_responses
    survey.responses.find_in_batches do |batch|
      Response.where(id: batch.map(&:id)).update_all(deleted_at: Time.current)
    end
  end
end
