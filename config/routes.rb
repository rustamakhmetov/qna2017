Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  concern :votable do
    member do
      patch 'vote_up'
      patch 'vote_down'
    end
  end

  resources :questions, concerns: [:votable] do
    resources :answers, shallow: true, except: %i[index show new edit], concerns: [:votable] do
      patch 'accept', on: :member
      resources :comments, only: %i[create]
    end
    resources :comments, only: %i[create]
  end

  resources :attachments, only: [:destroy]

  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], as: :finish_signup

  root 'questions#index'

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
      resources :questions
    end
  end
end
