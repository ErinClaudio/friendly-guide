Rails.application.routes.draw do
  get "oauth/authorize" => "oauth#authorize"
  get "oauth/exchange_token" => "oauth#exchange_token"
  get "activities" => "activities#index"
  delete "session" => "session#destroy"
end
