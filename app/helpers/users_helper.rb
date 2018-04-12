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

  def random_string(length)
    result = {}
    o = [('a'..'z'), ('A'..'Z'), (1..9)].map(&:to_a).flatten
    string = ((0...length).map { o[rand(o.length)] }.join) + (Time.now.strftime("%Y%m%d%H%M%S%L")).to_s
    result[:full] = string

    string = string[3..string.length] #
    result[:part] = string

    result
  end

  def token_slice(token)
    token[3..token.length] #
  end

  def equal_tokens(user, header_token_name)
    begin
      token_decode(user.token)[0]['token'] == token_slice(headers[header_token_name])
    rescue
      nil
    end
  end


end