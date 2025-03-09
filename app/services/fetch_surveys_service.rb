# frozen_string_literal: true

class FetchSurveysService
  class << self
    def call
      new.call
    end
  end

  def call
    surveys = Survey.includes(:responses).order(created_at: :desc)
    precompute_response_counts(surveys)
    surveys
  end

  private

  def precompute_response_counts(surveys)
    response_counts = Response
      .where(survey_id: surveys.select(:id))
      .group(:survey_id, :answer)
      .count
      .each_with_object({}) do |((survey_id, answer), count), hash|
      hash[survey_id] ||= {}
      hash[survey_id][answer] = count
    end

    surveys.each do |survey|
      survey.response_counts = response_counts[survey.id] || {}
    end
  end
end
