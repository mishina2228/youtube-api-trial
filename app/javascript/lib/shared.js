import I18n from 'i18n-js/translations'

const Shared = {}
Shared.setLocale = () => {
  I18n.locale = document.getElementsByTagName('body')[0].getAttribute('data-locale')
}
Shared.getCsrfToken = () => {
  return document.getElementsByName('csrf-token')[0].content
}
Shared.getFormMethod = form => {
  let method = form.getAttribute('method')
  const children = form.childNodes
  for (let i = 0; i < children.length; i++) {
    if (children[i].tagName.toLowerCase() === 'input' && children[i].name === '_method') {
      method = children[i].value
      break
    }
  }
  return method.toUpperCase()
}
Shared.sendAction = (form, accept = 'application/json') => {
  const url = form.getAttribute('action')

  return window.fetch(url, {
    method: Shared.getFormMethod(form),
    headers: {
      Accept: accept,
      'X-CSRF-Token': Shared.getCsrfToken()
    }
  })
}
Shared.urlWithCleanParams = urlString => {
  const url = new URL(urlString)

  const paramsArray = []
  url.searchParams.forEach((value, key) => {
    if (value === '') { return }
    paramsArray.push([key, value])
  })
  return `${url.origin}${url.pathname}?${(new URLSearchParams(paramsArray)).toString()}`
}

export { Shared }
