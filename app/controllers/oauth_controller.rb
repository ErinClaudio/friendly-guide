class OauthController < ApplicationController
  def authorize    
    redirect_to "https://www.strava.com/oauth/authorize?client_id=#{ENV['STRAVA_CLIENT_ID']}&response_type=code&redirect_uri=http://localhost:3000/oauth/exchange_token&scope=activity:read_all"
  end

  def exchange_token
    response = StravaService::Oauth.exchange_code(params[:code])

    redirect_to "http://localhost:3001/sign_in?state=failed" if !response 

    cookies[:strava_access_token] = { value: response.access_token, expires: Time.at(response.expires_at), httponly: true }
    cookies[:strava_access_token_expiration_date] = { value: response.expires_at, httponly: true }
    cookies[:strava_refresh_token] = { value: response.refresh_token, httponly: true }
    cookies[:strava_athlete] = { value: response.athlete }

    redirect_to "http://localhost:3001"
  end
end