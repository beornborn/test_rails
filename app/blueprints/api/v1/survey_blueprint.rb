# frozen_string_literal: true

module Api
  module V1
    class SurveyBlueprint < Blueprinter::Base
      identifier :id

      fields :question, :created_at

      field :response_counts do |survey|
        survey.response_counts
      end
    end
  end
end
