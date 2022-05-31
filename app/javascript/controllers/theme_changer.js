import Cookies from 'js-cookie'

window.addEventListener('turbo:load', () => {
  const darkModeBtn = document.querySelector('button.dark-mode-toggle')
  darkModeBtn.addEventListener('click', () => {
    changeTheme()
  })
})

const changeTheme = () => {
  const body = document.getElementsByTagName('body')[0]
  body.classList.toggle('dark_mode')
  const darkModeVal = body.classList.contains('dark_mode') ? 'isActive' : 'notActive'
  Cookies.set('dark_mode', darkModeVal)
}
