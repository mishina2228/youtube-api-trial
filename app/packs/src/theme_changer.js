import Cookies from 'js-cookie'

$(document).on('turbolinks:load', () => {
  $('button.dark-mode-toggle').click(() => {
    changeTheme()
  })
})

const changeTheme = () => {
  const body = $('body')
  body.toggleClass('dark_mode')
  const darkModeVal = body.hasClass('dark_mode') ? 'isActive' : 'notActive'
  Cookies.set('dark_mode', darkModeVal)
}
