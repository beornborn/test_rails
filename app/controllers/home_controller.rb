# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @user_uuid = current_user.uuid
  end

  private

  def current_user
    user = User.find_by(uuid: cookies.permanent[:user_uuid])

    if user.nil?
      user = User.create!(uuid: SecureRandom.uuid)
      cookies.permanent[:user_uuid] = user.uuid
    end

    user
  end
end
