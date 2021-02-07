import emojione from 'emoji-toolkit'
import Cookies from 'js-cookie'

$(document).on('turbolinks:load', () => {
  emojify();
  $('[data-toggle="tooltip"]').tooltip();
  $('#reset-search').on('click', reset_search_form);
  $('#search-result-pagination').on('ajax:beforeSend', _event => {
    const margin = $('nav.navbar-fixed-top').height();
    $('html, body').animate({scrollTop: $('#search-result').offset().top - margin});
  }).on('ajax:success', _event => {
  });
  $('button.dark-mode-toggle').click(() => {
    change_theme();
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
  $selects.each((_, elem) => $(elem).prop('selectedIndex', 0));
}

function change_theme() {
  const body = $('body');
  body.toggleClass('dark_mode');
  const dark_mode_val = body.hasClass('dark_mode') ? 'isActive' : 'notActive';
  Cookies.set('dark_mode', dark_mode_val);
}
