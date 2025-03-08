# frozen_string_literal: true

module Api
  module V1
    class SurveysController < Api::BaseController
      def index
        surveys = Survey.order(created_at: :desc)
        render json: render_surveys(surveys)
      end

      def create
        survey = Survey.new(survey_params.merge(user_id: current_user.id))

        if survey.save
          render json: render_surveys(survey), status: :created
        else
          render json: { errors: survey.errors }, status: :unprocessable_entity
        end
      end

      def show
        render json: render_surveys(survey)
      end

      def destroy
        if survey.user_id == current_user.id
          if survey.graceful_destroy
            head :no_content
          else
            render json: { errors: survey.errors }, status: :unprocessable_entity
          end
        else
          render json: { error: 'Not authorized to delete this survey' }, status: :forbidden
        end
      end

      private

      def survey_params
        params.require(:survey).permit(:question)
      end

      def survey
        @_survey ||= Survey.find(params[:id])
      end

      def render_surveys(surveys)
        Api::V1::SurveyBlueprint.render(surveys, user: current_user)
      end
    end
  end
end
