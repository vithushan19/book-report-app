Rails.application.routes.draw do
  root 'homepage#index'
  post "/homepage/search", to: "homepage#search"
  get "/homepage/get_recent_questions", to: "homepage#get_recent_questions"
  post "/homepage/delete_recent_question", to: "homepage#delete_recent_question"
end
