require 'open-uri'

class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
  end

  def tutorial
  end

  def evaluate
  end

  def expressions
    user_string = params[:user_string]
    @expression = LambdaExpression.new(user_string)
    @reduced_expression = @expression.beta_reduce

    @string_image = get_image_url(@expression)
    @reduced_expression_image = get_image_url(@reduced_expression)

    expression = {
      expression:             @expression,
      reducedExpression:      @reduced_expression,
      string:                 @expression.to_s,
      reducedString:          @reduced_expression.to_s,
      stringImage:            @string_image,
      reducedExpressionImage: @reduced_expression_image
    }

    render :json => expression

  end

  private
  def get_image_url(expression)
    path = expression.to_s.gsub(/\\/, ' \lambda ')
    'http://latex.codecogs.com/gif.latex?' + URI::encode(path)
  end
end
