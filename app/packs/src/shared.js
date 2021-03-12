import I18n from 'i18n-js'

const Shared = {}
Shared.set_locale = () => {
  I18n.locale = document.getElementsByTagName('body')[0].getAttribute('data-locale')
}
Shared.getCsrfToken = () => {
  return document.getElementsByName('csrf-token')[0].content
}

export { Shared }
