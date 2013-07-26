LambdaCalculus::Application.routes.draw do

  root to: 'application#index'

  get 'tutorial' => 'application#tutorial'
  get 'evaluate' => 'application#evaluate'
  post 'lambda_images' => 'application#lambda_images'

end
