namespace :theme_store, path: '/' do
  root 'welcome#homepage'
  get "authors_themes/:id"    => 'welcome#authors_themes', as: "authors_themes"
  get "demo/:id"              => 'welcome#demo', as: "demo"
  get 'homepage'              => 'welcome#homepage'
  get 'installing'            => 'welcome#installing'
  get 'learn_more'            => 'welcome#learn_more'
  get 'login'                 => 'welcome#login'
  get 'preview_in_store'      => 'welcome#preview_in_store'
  get "template_page/:id"     => 'welcome#template_page', as: "template_page"
  get "theme_page/:id"        => 'welcome#theme_page', as: "theme_page"
  get 'themes'                => 'themes#index'
end