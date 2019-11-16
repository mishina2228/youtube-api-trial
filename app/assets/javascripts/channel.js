$(document).on('turbolinks:load', () => {
  emojify();
  $('[data-toggle="tooltip"]').tooltip();
  $('#reset-search').on('click', reset_search_form);
  $('#search-result-pagination').on('ajax:beforeSend', _event => {
    const margin = $('nav.navbar-fixed-top').height();
    $('html, body').animate({scrollTop: $('form.search').offset().top - margin});
  }).on('ajax:success', _event => {
  });
});

function emojify() {
  $('.emojify').each((_, elem) => {
    const emojified = emojione.toImage($(elem).html());
    $(elem).html(emojified);
  });
}

function reset_search_form() {
  const $form = $('form.search');
  const $text_fields = $form.find('input[type="text"]');
  $text_fields.each((_, elem) => $(elem).val(''));
  const $selects = $form.find('select');
  $selects.each((_, elem) => $(elem).prop('selectedIndex', 0))
}
