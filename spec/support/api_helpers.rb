# frozen_string_literal: true

module ApiHelpers
  def json_response
    JSON.parse(response.body)
  end

  def authenticate_user(user = nil)
    user ||= create(:user)
    request.headers['X-User-UUID'] = user.uuid
    user
  end
end

RSpec.configure do |config|
  config.include ApiHelpers, type: :controller
end
