# frozen_string_literal: true

module UuidAuthenticatable
  extend ActiveSupport::Concern

  included do
    before_action :ensure_authenticated

    helper_method :current_user
  end

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = User.find_by(uuid: request.headers['X-User-Uuid'])
  end

  private

  def ensure_authenticated
    render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user.present?
  end
end
