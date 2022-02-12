import I18n from 'i18n-js/translations'
import { Shared } from 'lib/shared'

const propSubmitButton = () => {
  Shared.set_locale()
  document.querySelectorAll('form.create-channel').forEach(elem => {
    elem.addEventListener('ajax:beforeSend', event => {
      const button = event.currentTarget.querySelector('input[type="submit"]')
      button.setAttribute('disabled', 'disabled')
      button.value = I18n.t('helpers.notice.processing')
    })
    elem.addEventListener('ajax:success', event => {
      const button = event.currentTarget.querySelector('input[type="submit"]')
      button.classList.add('btn-secondary')
      button.classList.remove('btn-primary')
      button.value = I18n.t('helpers.link.channel_created')
    })
    elem.addEventListener('ajax:error', event => {
      const button = event.currentTarget.querySelector('input[type="submit"]')
      button.classList.add('btn-danger')
      button.classList.remove('btn-primary')
      button.value = I18n.t('helpers.link.channel_create_failed')
    })
  })
}

window.propSubmitButton = propSubmitButton
