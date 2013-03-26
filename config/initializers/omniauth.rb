Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['APP_ID'], ENV['APP_SECRET']
end
