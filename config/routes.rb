Website::Application.routes.draw do
<<<<<<< HEAD
  get "home/index"
  root "home#index"
=======
  mount Faalis::Engine => "/"

  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      resources :newsletters, :except => [:new]
      resources :newsletter_users, :except => [:new]
    end
  end
>>>>>>> dcd40c68c9ab691a92e47ec72a2ff3cdc919c600

end
