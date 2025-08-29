Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if Rails.env.development?

  if Rails.env.production?
    provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {
      :scope => "email, profile",
      :callback_path => '/auth/google_oauth2/callback',
      :request_path => '/auth/google_oauth2'
    }

    provider :line, ENV['LINE_CLIENT_ID'], ENV['LINE_CLIENT_SECRET'], {
      :scope => "profile openid email",
      :callback_path => '/auth/line/callback',
      :request_path => '/auth/line'
    }
  else
    provider :google_oauth2, Rails.application.credentials.dig(:google, :client_id), Rails.application.credentials.dig(:google, :client_secret), scope: "email, profile"
    provider :line, Rails.application.credentials.dig(:line, :client_id), Rails.application.credentials.dig(:line, :client_secret), scope: "profile openid email"
  end

  OmniAuth.config.on_failure = Proc.new do |env|
    OmniAuth::FailureEndpoint.new(env).redirect_to_failure
  end
end