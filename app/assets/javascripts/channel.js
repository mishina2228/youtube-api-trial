$(document).on('turbolinks:load', (function () {
  emojify();
  $('[data-toggle="tooltip"]').tooltip();
  $('#reset-search').click(reset_search_form);
}));

function emojify() {
  $('.emojify').each(function(){
    const emojified = emojione.toImage($(this).html());
    $(this).html(emojified);
  });
}

function reset_search_form() {
  const $form = $('form.search');
  const $forms = $form.find('input[type="text"], select');
  $forms.each((_, elem) => $(elem).val(''))
}
