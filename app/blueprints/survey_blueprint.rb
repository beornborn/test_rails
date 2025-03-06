# frozen_string_literal: true

class SurveyBlueprint < Blueprinter::Base
  identifier :id

  fields :question, :created_at

  field :response_counts do |survey|
    survey.response_counts
  end
end
