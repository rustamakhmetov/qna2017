Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :questions do
    resources :answers, shallow: true, except: [:index, :show, :new, :edit] do
      patch 'accept', on: :member
    end
  end
  root 'questions#index'
end
