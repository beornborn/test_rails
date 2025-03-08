# frozen_string_literal: true

class SurveyService
  attr_reader :survey

  def self.delete_survey(survey)
    new(survey).delete
  end

  def initialize(survey)
    @survey = survey
  end

  def delete
    ActiveRecord::Base.transaction do
      delete_responses
      survey.destroy
    end
  end

  private

  def delete_responses
    survey.responses.find_in_batches do |batch|
      Response.where(id: batch.map(&:id)).update_all(deleted_at: Time.current)
    end
  end
end
