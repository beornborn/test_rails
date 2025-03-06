# frozen_string_literal: true

module UuidAuthenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user
  end

  private

  def authenticate_user
    uuid = request.headers['X-User-UUID']

    if uuid.present?
      @current_user = User.find_by(uuid: uuid)
    else
      @current_user = User.create!(uuid: SecureRandom.uuid)
      response.headers['X-User-UUID'] = @current_user.uuid
    end
  end

  def current_user
    @current_user
  end
end
