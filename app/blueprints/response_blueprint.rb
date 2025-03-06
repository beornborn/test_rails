# frozen_string_literal: true

class ResponseBlueprint < Blueprinter::Base
  identifier :id

  fields :answer, :survey_id, :created_at
end
