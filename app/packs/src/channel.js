import emojione from 'emoji-toolkit'
import iziToast from 'izitoast'
import I18n from './i18n.js.erb'
import { Shared } from './shared'

document.addEventListener('turbolinks:load', () => {
  emojify()
  $('[data-toggle="tooltip"]').tooltip()
  $('#reset-search').on('click', resetSearchForm)
  const loaderBg = document.querySelector('.loader-bg')
  $('#search-result-pagination').on('ajax:beforeSend', _event => {
    document.querySelectorAll('nav ul .page-item').forEach(element => {
      element.classList.add('disabled')
    })
    loaderBg.style.display = 'block'
    const margin = $('div.fixed-top').height()
    $('html, body').animate({ scrollTop: $('#search-result').offset().top - margin })
  }).on('ajax:success', _event => {
    loaderBg.style.display = 'none'
  })
  Shared.set_locale()
  prepBuildStatistics()
  prepUpdateSnippet()
  prepUpdateAllSnippets()
  prepBuildAllStatistics()
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

const prepUpdateSnippet = () => {
  setEventToBtn('update-snippet-btn', I18n.t('text.channel.update_snippet.error'))
}

const prepBuildStatistics = () => {
  setEventToBtn('build-statistics-btn', I18n.t('text.channel.build_statistics.error'))
}

const prepUpdateAllSnippets = () => {
  setEventToBtn('update-all-snippets-btn', I18n.t('text.channel.update_snippet.error'))
}

const prepBuildAllStatistics = () => {
  setEventToBtn('build-all-statistics-btn', I18n.t('text.channel.build_statistics.error'))
}

const setEventToBtn = (btnId, errorMessage = null) => {
  const btn = document.getElementById(btnId)
  if (!btn) {
    return
  }

  triggerAndNotify(btn, errorMessage)
}

const triggerAndNotify = (btn, errorMessage = null) => {
  btn.addEventListener('click', e => {
    e.preventDefault()
    const form = e.currentTarget.parentNode

    Shared.sendAction(form)
      .then(res => {
        if (!res.ok) {
          throw new Error(`${res.status} ${res.statusText}`)
        }
        return res.json()
      })
      .then(json => {
        iziToast.success({ title: json.message, position: 'bottomRight' })
      })
      .catch(err => {
        iziToast.error({ message: errorMessage || err.message, position: 'bottomRight' })
      })
  })
}
