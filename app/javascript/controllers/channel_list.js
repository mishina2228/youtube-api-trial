import I18n from 'i18n-js'
import { Shared } from 'controllers/shared'

const propSubmitButton = () => {
  Shared.set_locale()
  $('form.create-channel').on('ajax:beforeSend', event => {
    const button = event.currentTarget.querySelector('input[type="submit"]')
    button.setAttribute('disabled', 'disabled')
    button.value = I18n.t('helpers.notice.processing')
  }).on('ajax:success', event => {
    const button = event.currentTarget.querySelector('input[type="submit"]')
    button.classList.add('btn-secondary')
    button.classList.remove('btn-primary')
    button.value = I18n.t('helpers.link.channel_created')
  }).on('ajax:error', event => {
    const button = event.currentTarget.querySelector('input[type="submit"]')
    button.classList.add('btn-danger')
    button.classList.remove('btn-primary')
    button.value = I18n.t('helpers.link.channel_create_failed')
  })
}

window.propSubmitButton = propSubmitButton
