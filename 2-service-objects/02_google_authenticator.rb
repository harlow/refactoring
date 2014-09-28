class GoogleAuthenticator
  def initialize(user)
    @user = user
  end

  def authenticate(short_lived_token)
    oauth_response = oauth_client.auth_code.get_token(
      short_lived_token,
      redirect_uri: ENV['GOOGLE_REDIRECT_URI']
    )

    @user && oauth_response.token
  rescue OAuth2::Error => e
    Rails.logger.info("Google Authenication Failed: #{e}")
    false
  end

  private

  def oauth_client
    OAuth2::Client.new(
      ENV['GOOGLE_CLIENT_ID'],
      ENV['GOOGLE_CLIENT_SECRET'],
      site: 'https://accounts.google.com',
      authorize_url: '/o/oauth2/auth',
      token_url: '/o/oauth2/token'
    )
  end
end
