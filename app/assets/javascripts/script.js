$(function(){
  "use strict";

  $("form#evaluate").submit(function(){
    $.get($("form#evaluate").attr("value"), );
    // Get from Ruby the expression image and the reduced expression image.
    // Put rendered expression under the field.
    // Make new row and put beta reduced image there with new evaluate button
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

});