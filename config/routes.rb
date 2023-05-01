Rails.application.routes.draw do
  root 'homepage#index'
  post "/homepage/search", to: "homepage#search"
end
