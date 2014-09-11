Timesheet::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.

  root 'users#index'

  Rails::Engine.descendants.
    reject { |x| x == Rails::Application }. # because Rails::Application is abstract and cause error on next line
    select { |x| x.config.root.to_s.include? 'plugins/connectors' }.
    each { |x| mount x, at: "connectors/#{x.engine_name}" }

  get '/no_payroll' => 'welcome#no_payroll'
  get '/no_pdf' => 'welcome#no_pdf'

  get 'time_entries' => 'time_entries#index'
  get 'users/:id/time_entries' => 'time_entries#show', as: 'user_time_entries'
  get 'users/:id/invoices' => 'invoices#user_invoices', as: 'user_invoices'

  resources :invoices do
    member { get :download }
  end
  resources :invoices_packs do
    member do
      post :to_elastic
      get :download
    end
  end
  resources :user_reports do
    patch :update_summary
    patch :update_fee
  end

  resources :reports do
    get :xml
    resources :user_reports do
      resources :fees
      resources :invoices
    end
    resources :invoices_packs do
      resources :invoices
    end
  end

  resources :users do
    resources :time_entries
    resources :invoices
    resources :user_reports
    resources :payrolls
    member do
      get :hide
      get :unhide
    end
  end

  post 'users/syncronize' => 'users#syncronize'
  post 'time_entries/syncronize' => 'time_entries#syncronize'

  resources :connectors
  post 'connectors/synchronize' => 'connectors#synchronize'
end
