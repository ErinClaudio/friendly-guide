module StravaService

  module Oauth
    class InvalidSession < StandardError ; end

    class << self
      def exchange_code(code)
        response = HTTParty.post("https://www.strava.com/api/v3/oauth/token", body: {
          client_id: ENV['STRAVA_CLIENT_ID'],
          client_secret: ENV['STRAVA_CLIENT_SECRET'],
          code: code,
          grant_type: "authorization_code"
        })

        return false if !response.success?

        return OpenStruct.new(
          response.slice("access_token", "refresh_token", "expires_at")
          .merge("athlete": response["athlete"].to_json))
      end

      def refresh_token(refresh_token)
        response = HTTParty.post("https://www.strava.com/oauth/token", body: {
          client_id: ENV['STRAVA_CLIENT_ID'],
          client_secret: ENV['STRAVA_CLIENT_SECRET'],
          grant_type: "refresh_token",
          refresh_token: refresh_token
        })
        return false if !response.success?

        return OpenStruct.new(response.slice("access_token", "refresh_token", 
                                             "expires_at"))
      end
    end
  end
  
  module Athlete
    class << self
      def list_activities(access_token)        
        response = HTTParty.get("https://www.strava.com/api/v3/athlete/activities", headers: {
          "Authorization": "Bearer #{access_token}"
        })
        return false if !response.success?

        data = JSON.parse(response.body)
        return data.map do |activity|
            activity.slice("name", "distance", "moving_time", "elapsed_time", 
                           "total_elevation_gain", "sport_type", "start_date")
        end
      end
    end
  end
end