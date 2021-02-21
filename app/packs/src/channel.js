import emojione from 'emoji-toolkit'

$(document).on('turbolinks:load', () => {
  emojify()
  $('[data-toggle="tooltip"]').tooltip()
  $('#reset-search').on('click', resetSearchForm)
  $('#search-result-pagination').on('ajax:beforeSend', _event => {
    document.querySelectorAll('nav ul .page-item').forEach(element => {
      element.classList.add('disabled')
    })
    const margin = $('div.fixed-top').height()
    $('html, body').animate({ scrollTop: $('#search-result').offset().top - margin })
  }).on('ajax:success', _event => {
  })
})

const emojify = () => {
  $('.emojify').each((_, elem) => {
    const emojified = emojione.toImage($(elem).html())
    $(elem).html(emojified)
  })
}

const resetSearchForm = () => {
  const $form = $('form.search')
  const $textFields = $form.find('input[type="text"]')
  $textFields.each((_, elem) => $(elem).val(''))
  const $selects = $form.find('select')
  $selects.each((_, elem) => $(elem).prop('selectedIndex', 0))
}
