# frozen_string_literal: true

module Api
  module V1
    class ResponseBlueprint < Blueprinter::Base
      identifier :id

      fields :answer, :survey_id, :created_at
    end
  end
end
