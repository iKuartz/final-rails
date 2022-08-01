class JsonWebToken
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

  def self.encode(payload, algo = 'HS256')
    JWT.encode payload, SECRET_KEY, algo
  end

  def self.decode(token, algo = 'HS256')
    decoded_token = JWT.decode token, SECRET_KEY, true, { algorithm: algo }
    decoded_token[0]['name']
  end
end
