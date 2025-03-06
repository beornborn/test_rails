# frozen_string_literal: true

module Api
  class BaseController < ApplicationController
    include UuidAuthenticatable
  end
end
