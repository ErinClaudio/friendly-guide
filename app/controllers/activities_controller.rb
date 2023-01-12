class ActivitiesController < ApplicationController
  before_action :validate_session

  def index
    response = StravaService::Athlete.list_activities(cookies[:strava_access_token])

    if !response
      render json: { error: "Bad Request" }, status: :bad_request
    else
      render json: response, status: :ok
    end
  end
end