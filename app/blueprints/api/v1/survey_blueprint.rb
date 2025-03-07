# frozen_string_literal: true

module Api
  module V1
    class SurveyBlueprint < Blueprinter::Base
      identifier :id

      fields :question, :created_at

      field :response_counts do |survey|
        survey.response_counts
      end

      field :user_responded do |survey, options|
        survey.user_responded?(user: options[:user])
      end

      field :user_creator do |survey, options|
        options[:user] && survey.user_id == options[:user].id
      end
    end
  end
end
