OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '105104383154185', '38399d045718889e8912ea7c3d433f4f'
end
