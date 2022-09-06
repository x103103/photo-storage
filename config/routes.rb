Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get '*path' => "home#show"
  root "home#show"
end
