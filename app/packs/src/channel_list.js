import I18n from './i18n.js.erb'

const propSubmitButton = () => {
  I18n.locale = document.getElementsByTagName('body')[0].getAttribute('data-locale')
  $('form.create-channel').on('ajax:beforeSend', event => {
    const button = $(event.currentTarget).find('input[type="submit"]')
    button.prop('disabled', true)
    button.val(I18n.t('helpers.notice.processing'))
  }).on('ajax:success', event => {
    const button = $(event.currentTarget).find('input[type="submit"]')
    button.addClass('btn-secondary')
    button.removeClass('btn-primary')
    button.val(I18n.t('helpers.link.channel_created'))
  }).on('ajax:error', event => {
    const button = $(event.currentTarget).find('input[type="submit"]')
    button.addClass('btn-danger')
    button.removeClass('btn-primary')
    button.val(I18n.t('helpers.link.channel_create_failed'))
  })
}

global.propSubmitButton = propSubmitButton
