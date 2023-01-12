class ApplicationController < ActionController::API
  include ActionController::Cookies

  rescue_from StravaService::Oauth::InvalidSession do |exception|
    render json: { error: exception }, status: :forbidden
  end

  def validate_session
    if cookies[:strava_access_token].nil? || cookies[:strava_access_token_expiration_date].nil?
      raise StravaService::Oauth::InvalidSession.new("Invalid Session")
    elsif Time.at(cookies[:strava_access_token_expiration_date].to_i) < Time.now
      refresh_session
    end
  end

  private

  def refresh_session
    response = StravaService::Oauth.refresh_token(cookies[:strava_refresh_token])
    raise StravaService::Oauth::InvalidSession.new("Invalid Session") if !response

    cookies[:strava_access_token] = { value: response.access_token, expires: Time.at(response.expires_at), httponly: true }
    cookies[:strava_access_token_expiration_date] = { value: Time.at(response.expires_at), httponly: true }
    cookies[:strava_refresh_token] = { value: response.refresh_token, httponly: true }
  end
end
