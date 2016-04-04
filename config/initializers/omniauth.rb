OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1179405328750092', '03a2137a9c36c737077240da130c2ac2'
end