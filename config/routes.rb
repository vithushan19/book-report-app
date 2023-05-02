Rails.application.routes.draw do
  root 'homepage#index'
  post "/homepage/search", to: "homepage#search"
  get "/homepage/get_recent_questions", to: "homepage#get_recent_questions"
end
