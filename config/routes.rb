
Rails.application.routes.draw do
  get 'documents/index'

  get 'documents/new'

  get 'documents/create'

  get 'documents/destroy'

  devise_for :users, skip: :registration

  root 'home#index'

  # Contacts controller
  get '/contacts',to:'contacts#index'

  # Home controller routes
  get 'home/index'


  # get 'announcement/index'
  resources :announcement, :path => 'announcement' #gives CRUD routes

  # scheulde
  get '/schedule', to: 'schedule#index'

  # Permissions routes
  get '/permissions', to: 'permissions#index'
  delete 'permissions/destroy'


  #documents
  get '/documents' => 'documents#index'

  BadgerNet::Application.routes.draw do
    resources :documents, only: [:index, :new, :create, :destroy]
    root "documents#index"
  end

end
