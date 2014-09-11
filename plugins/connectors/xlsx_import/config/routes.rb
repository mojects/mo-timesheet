XlsxImport::Engine.routes.draw do
  root 'xlsx#new'
  resources :xlsx
end
