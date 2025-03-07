# frozen_string_literal: true

module Api
  module V1
    class SurveysController < Api::BaseController
      def index
        surveys = Survey.all
        render json: Api::V1::SurveyBlueprint.render(surveys)
      end

      def create
        survey = Survey.new(survey_params)

        if survey.save
          render json: Api::V1::SurveyBlueprint.render(survey), status: :created
        else
          render json: { errors: survey.errors }, status: :unprocessable_entity
        end
      end

      def show
        survey = Survey.find(params[:id])
        render json: Api::V1::SurveyBlueprint.render(survey)
      end

      private

      def survey_params
        params.require(:survey).permit(:question)
      end
    end
  end
end
