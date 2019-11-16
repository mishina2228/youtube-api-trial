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
  const $forms = $form.find('input[type="text"], select');
  $forms.each((_, elem) => $(elem).val(''))
}
