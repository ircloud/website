Website::Application.routes.draw do
  mount Faalis::Engine => "/"

  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      resources :newsletters, :except => [:new]
      resources :newsletter_users, :except => [:new]
    end
  end

end
