Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  concern :votable do
    member do
      patch 'vote_up'
      patch 'vote_down'
    end
  end

  resources :questions do
    resources :answers, shallow: true, except: [:index, :show, :new, :edit] do
      patch 'accept', on: :member
      concerns :votable
    end
    concerns :votable
  end

  resources :attachments, only: [:destroy]

  root 'questions#index'
end
