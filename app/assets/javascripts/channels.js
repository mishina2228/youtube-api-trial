$(document).on('turbolinks:load', (function () {
  emojify();
}));

function emojify() {
  $('.emojify').each(function(){
    const emojified = emojione.toImage($(this).html());
    $(this).html(emojified);
  });
}
