# frozen_string_literal: true

class SurveysController < ApplicationController
  include UuidAuthenticatable

  def index
    @surveys = Survey.all
    render json: SurveyBlueprint.render(@surveys)
  end

  def create
    @survey = Survey.new(survey_params)

    if @survey.save
      render json: SurveyBlueprint.render(@survey), status: :created
    else
      render json: { errors: @survey.errors }, status: :unprocessable_entity
    end
  end

  def show
    @survey = Survey.find(params[:id])
    render json: SurveyBlueprint.render(@survey)
  end

  private

  def survey_params
    params.require(:survey).permit(:question)
  end
end
