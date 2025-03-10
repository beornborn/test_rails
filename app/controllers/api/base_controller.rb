# frozen_string_literal: true

module Api
  class BaseController < ApplicationController
    private

    def current_user
      @current_user ||= begin
        uuid = request.headers['X-User-UUID']
        if uuid.present?
          User.find_by(uuid: uuid) || User.create!(uuid: uuid)
        else
          User.create!(uuid: SecureRandom.uuid)
        end
      end
    end
  end
end
