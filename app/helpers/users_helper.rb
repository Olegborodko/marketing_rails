module UsersHelper
  def token_encode(password)
    payload = { password: password, time: Time.now }
    token = JWT.encode payload, Rails.application.secrets.token_secret_key, 'HS256'

    Base64.strict_encode64(token)
  end

  def token_encode_for_take(value)
    payload = { token: value, time: Time.now }
    token = JWT.encode payload, Rails.application.secrets.token_secret_key, 'HS256'

    Base64.strict_encode64(token)
  end

  def token_decode(token)
    begin
      temp = Base64.strict_decode64(token)
      JWT.decode temp, Rails.application.secrets.token_secret_key, true, { algorithm: 'HS256' }
    rescue
      nil
    end
  end
end