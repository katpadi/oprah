module Helpers
  module AuthHelpers
    extend ActiveSupport::Concern
    included do
      http_basic do |email, password|
        user = User.find_by email: email
        @current_user = user if user && user.valid_password?(password)
        render_error!('unauthorized_error', 'Unauthorized access', 401) unless @current_user
        @current_user
      end
    end
  end
end


