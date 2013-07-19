LambdaCalculus::Application.routes.draw do

  root to: 'lambda_expressions#index'

  resources :lambda_expressions

  post 'images' => 'lambda_expressions#images'

end
