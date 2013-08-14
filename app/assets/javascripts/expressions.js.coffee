$ ->
  $("form.beta_reduce").on "submit", () ->
    event.preventDefault()

    form = $(this)

    $.ajax
      url: form.attr "action"
      type: form.attr "method"
      data: form.serialize()
      dataType: "json"
      success: (expression) ->
        stringImage = expression.stringImage
        reducedExpressionImage = expression.reducedExpressionImage
        reducedExpressionElement = "<p><img src='" + stringImage + "' /> reduces to <img src='" + reducedExpressionImage + ".' /></p><br>"
        $(reducedExpressionElement).hide().appendTo(form.parent()).fadeIn()

# $("form.animate").click(function(){
#   $("img").last().animate({
#     top: "-=20"
#   }, 1000).animate({
#     left: "-=40"
#   }, 1000).animate({
#     top: "+=20"
#   }, 1000);
# });