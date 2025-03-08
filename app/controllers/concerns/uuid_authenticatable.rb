# frozen_string_literal: true

module UuidAuthenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user
  end

  private

  def authenticate_user
    cookies.permanent[:user_uuid] ||= SecureRandom.uuid
    @current_user = User.find_or_create_by(uuid: cookies.permanent[:user_uuid])
  end

  def current_user
    @current_user
  end
end
