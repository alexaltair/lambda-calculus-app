require 'open-uri'

class LambdaExpressionsController < ApplicationController

  def index
  end

  def images
    user_string = params[:user_string]
    @user_expression = LambdaExpression.new(user_string)
    @reduced_expression = @user_expression.beta_reduce

    @user_string_image = get_image_url(@user_expression)
    @reduced_expression_image = get_image_url(@reduced_expression)
  end

  private
  def get_image_url(expression)
    path = expression.to_s.gsub(/\\/, ' \lambda ')
    'http://latex.codecogs.com/gif.latex?' + URI::encode(path)
  end

end