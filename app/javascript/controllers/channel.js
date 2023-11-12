import iziToast from 'izitoast'
import I18n from 'i18n-js/translations'
import { Shared } from 'lib/shared'
import { Tooltip } from 'bootstrap'

document.addEventListener('turbo:load', () => {
  initializeTooltips()
  document.getElementById('reset-search')?.addEventListener('click', resetSearchForm)

  Shared.setLocale()
  prepBuildStatistics()
  prepUpdateSnippet()
  prepUpdateAllSnippets()
  prepBuildAllStatistics()
})

const resetSearchForm = () => {
  const form = document.querySelector('form.search')
  const inputFields = form.querySelectorAll('input[type="text"], input[type="number"]')
  inputFields.forEach(elem => { elem.value = '' })
  const selects = form.querySelectorAll('select')
  selects.forEach(elem => { elem.selectedIndex = 0 })
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
  btn.errorMessage = errorMessage
  btn.addEventListener('click', notify)
}

const notify = event => {
  event.preventDefault()
  const form = event.currentTarget.parentNode

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
      iziToast.error({ message: event.currentTarget.errorMessage || err.message, position: 'bottomRight' })
    })
}

const initializeTooltips = () => {
  const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-toggle="tooltip"]'))
  tooltipTriggerList.map(tooltipTriggerEl => new Tooltip(tooltipTriggerEl))
}
