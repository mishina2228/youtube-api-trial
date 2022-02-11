const toggleAuthMethod = button => {
  propFields(document.querySelectorAll('.auth-field .auth-field-group'), false)

  const authMethod = button.value
  switch (authMethod) {
    case 'api_key':
    case 'oauth2': {
      propFields(document.querySelectorAll(`.auth-field.${authMethod} .auth-field-group`), button.checked)
      break
    }
    default: {
      console.error('Unrecognized authentication method: ' + authMethod)
    }
  }
}

const propFields = (fields, enable) => {
  fields.forEach(formGroup => {
    formGroup.querySelectorAll('input').forEach(field => {
      enable ? field.removeAttribute('disabled') : field.setAttribute('disabled', 'disabled')
    })
    enable ? formGroup.style.display = '' : formGroup.style.display = 'none'
  })
}

const changePassword = link => {
  link.style.display = 'none'
  link.nextElementSibling.style.display = ''
}

document.addEventListener('turbolinks:load', () => {
  if (document.URL.match(/system_setting\/(edit|new)/)) {
    propFields(document.querySelectorAll('.auth-field .auth-field-group'), false)
    document.querySelectorAll('.auth-methods input[type="radio"]').forEach(elem => {
      elem.addEventListener('change', event => {
        toggleAuthMethod(event.currentTarget)
      })
    })
    document.querySelector('.auth-methods input[type="radio"]:checked')
      .dispatchEvent(new window.Event('change'))
    document.querySelector('.change-client-secret').addEventListener('click', event => {
      changePassword(event.currentTarget)
    })
  }
})
