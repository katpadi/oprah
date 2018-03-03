# spec/support/request_spec_helper
module RequestSpecHelper
  # Parse JSON response to ruby hash
  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end

  def auth_for(user)
    {
      'HTTP_AUTHORIZATION'  => ActionController::HttpAuthentication::Basic.encode_credentials(user.email, '12345678')
    }
  end

  def bad_auth
    { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials('drake', 'h0tlineBl1ing') }
  end
end
