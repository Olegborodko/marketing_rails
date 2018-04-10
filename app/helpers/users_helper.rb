module UsersHelper
  def token_encode(password)
    payload = { password: password, time: Time.now }
    token = JWT.encode payload, Rails.application.secrets.token_secret_key, 'HS256'

    Base64.strict_encode64(token)
  end
end