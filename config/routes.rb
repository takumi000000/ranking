Rails.application.routes.draw do
  get 'rank/index'
  get 'rank/show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'charts/monthly'
  
end
