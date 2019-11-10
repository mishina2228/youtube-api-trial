$(document).on('turbolinks:load', (function () {
  emojify();
  $('[data-toggle="tooltip"]').tooltip();
}));

function emojify() {
  $('.emojify').each(function(){
    const emojified = emojione.toImage($(this).html());
    $(this).html(emojified);
  });
}
