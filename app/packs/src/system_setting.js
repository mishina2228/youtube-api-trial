const toggleAuthMethod = button => {
  propFields($('.auth-field').find('.form-group'), false)

  const authMethod = button.val()
  switch (authMethod) {
    case 'api_key':
    case 'oauth2': {
      const checked = button.is(':checked')
      propFields($('.' + authMethod).find('.form-group'), checked)
      break
    }
    default: {
      console.error('Unrecognized authentication method: ' + authMethod)
    }
  }
}

const propFields = (fields, enable) => {
  fields.each((_, formGroup) => {
    $(formGroup).find('input').each((_, field) => {
      $(field).prop('disabled', !enable)
    })
    enable ? $(formGroup).show() : $(formGroup).hide()
  })
}

const changePassword = link => {
  link.hide()
  link.next('input[type="password"]').show()
}

$(document).on('turbolinks:load', () => {
  if (document.URL.match(/system_setting\/edit/)) {
    propFields($('.auth-field').find('.form-group'), false)
    $('.auth-methods input[type="radio"]').on('change', event =>
      toggleAuthMethod($(event.currentTarget))
    )
    $('.auth-methods input[type="radio"]:checked').change()
    $('.change-client-secret').on('click', event =>
      changePassword($(event.currentTarget))
    )
  }
})
