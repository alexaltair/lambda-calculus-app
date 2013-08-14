$(function(){
  "use strict";

  $("form.beta_reduce").on("submit", function(){
    event.preventDefault();

    var form = $(this);

    $.ajax({
      url: form.attr("action"),
      type: form.attr("method"),
      data: form.serialize(),
      dataType: "json",
      success: function(expression) {
        var stringImage = expression.stringImage;
        var reducedExpressionImage = expression.reducedExpressionImage;

        $("<br><p><img src='"+stringImage+"' /> reduces to <img src='"+reducedExpressionImage+".' /></p>").hide().appendTo(form.parent()).fadeIn();
      }
    })
  });
});


// $("form.animate").click(function(){
//   $("img").last().animate({
//     top: "-=20"
//   }, 1000).animate({
//     left: "-=40"
//   }, 1000).animate({
//     top: "+=20"
//   }, 1000);
// });