import iziToast from 'izitoast'
import I18n from 'i18n-js/translations'
import { Shared } from 'lib/shared'
import { Tooltip } from 'bootstrap'

document.addEventListener('turbolinks:load', () => {
  initializeTooltips()
  document.getElementById('reset-search')?.addEventListener('click', resetSearchForm)
  const loaderBg = document.querySelector('.loader-bg')
  const searchResult = document.getElementById('search-result')
  let scrollTop = false

  const searchResultPagination = document.getElementById('search-result-pagination')
  searchResultPagination?.addEventListener('ajax:beforeSend', () => {
    document.querySelectorAll('nav ul .page-item').forEach(element => {
      element.classList.add('disabled')
    })
    loaderBg.style.display = 'block'
    searchResult.style.opacity = '0.3'
    scrollTop = true // scroll to the top of table if paginated
  })
  searchResultPagination?.addEventListener('ajax:success', () => {
    loaderBg.style.display = 'none'
    searchResult.style.opacity = '1'
    searchResult.animate({ opacity: [0, 1] }, { duration: 500 })
    if (scrollTop) {
      const margin = document.querySelector('div.fixed-top').clientHeight
      window.scroll(0, getOffset('search-result') - margin)
    }
    scrollTop = false // reset variable
    initializeTooltips()
  })

  displayLoaderImg('form.search')
  Shared.setLocale()
  prepBuildStatistics()
  prepUpdateSnippet()
  prepUpdateAllSnippets()
  prepBuildAllStatistics()
})

const getOffset = (id) => {
  const elem = document.getElementById(id)
  const rectangle = elem.getBoundingClientRect()
  const scrollTop = window.pageYOffset || document.documentElement.scrollTop
  return rectangle.top + scrollTop
}

const resetSearchForm = () => {
  const form = document.querySelector('form.search')
  const inputFields = form.querySelectorAll('input[type="text"], input[type="number"]')
  inputFields.forEach(elem => { elem.value = '' })
  const selects = form.querySelectorAll('select')
  selects.forEach(elem => { elem.selectedIndex = 0 })
}

const displayLoaderImg = (query) => {
  const loaderBg = document.querySelector('.loader-bg')
  document.querySelectorAll(query).forEach(element => {
    element.addEventListener('ajax:beforeSend', _event => {
      loaderBg.style.display = 'block'
    })
    element.addEventListener('ajax:success', _event => {
      loaderBg.style.display = 'none'
    })
    element.addEventListener('ajax:error', event => {
      loaderBg.style.display = 'none'
      iziToast.error({ message: I18n.t('text.common.error_message'), position: 'bottomRight' })
      console.error(event)
    })
  })
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

const initializeTooltips = () => {
  const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-toggle="tooltip"]'))
  tooltipTriggerList.map(tooltipTriggerEl => new Tooltip(tooltipTriggerEl))
}
