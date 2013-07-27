LambdaCalculus::Application.routes.draw do

  root to: 'application#index'

  get 'tutorial' => 'application#tutorial'
  get 'evaluate' => 'application#evaluate'
  post 'expressions' => 'application#expressions'

end
