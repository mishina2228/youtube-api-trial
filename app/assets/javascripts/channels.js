$(document).on('turbolinks:load', (function () {
  emojify();
}));

function emojify() {
  const $contents = $('.emojify');
  const emojified = emojione.toImage($contents.html());
  $contents.html(emojified);
}
