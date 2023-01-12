class SessionController < ApplicationController
  def destroy
    cookies.delete :strava_access_token
    cookies.delete :strava_access_token_expiration_date
    cookies.delete :strava_refresh_token
    cookies.delete :strava_athlete

    render json: { status: "ok" }, status: :ok
  end
end