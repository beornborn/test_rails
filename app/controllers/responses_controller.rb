# frozen_string_literal: true

class ResponsesController < ApplicationController
  include UuidAuthenticatable

  def create
    @survey = Survey.find(params[:survey_id])
    @response = @survey.responses.build(response_params.merge(user: current_user))

    if @response.save
      render json: ResponseBlueprint.render(@response), status: :created
    else
      render json: { errors: @response.errors }, status: :unprocessable_entity
    end
  end

  private

  def response_params
    params.require(:response).permit(:answer)
  end
end
