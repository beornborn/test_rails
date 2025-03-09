# frozen_string_literal: true

module Api
  module V1
    class ResponsesController < Api::BaseController
      def create
        survey = Survey.find(params[:survey_id])
        response = survey.responses.build(response_params.merge(user: current_user))

        if response.save
          render json: Api::V1::ResponseBlueprint.render(response), status: :created
        else
          render json: { errors: response.errors }, status: :unprocessable_entity
        end
      end

      def own
        response = Response.find_by!(survey_id: params[:survey_id], user: current_user)

        if response.destroy
          render json: {}, status: :ok
        else
          render json: { errors: response.errors }, status: :unprocessable_entity
        end
      end

      private

      def response_params
        params.require(:response).permit(:answer)
      end
    end
  end
end
