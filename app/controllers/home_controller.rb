# frozen_string_literal: true

class HomeController < ApplicationController
  include UuidAuthenticatable

  def index
    @user_uuid = current_user.uuid
  end
end
