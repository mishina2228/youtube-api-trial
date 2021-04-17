import { Shared } from './shared'
import Tagify from '@yaireo/tagify'

document.addEventListener('turbolinks:load', () => {
  const btn = document.getElementById('edit-channel-tag-btn')
  if (btn) {
    prepEditChannelTag(btn)
  }
})

const prepEditChannelTag = btn => {
  btn.addEventListener('click', e => {
    e.preventDefault()
    const form = e.currentTarget.parentNode
    Shared.sendAction(form, 'text/html')
      .then(res => {
        if (!res.ok) {
          throw new Error(`${res.status} ${res.statusText}`)
        }
        return res.text()
      })
      .then(html => {
        document.querySelector('.channel.tag-list').innerHTML = html
        const channelTags = document.querySelector('input.channel-tags')
        const tagify = new Tagify(channelTags, {
          delimiters: null,
          whitelist: []
        })
        tagify.on('input', e => { tagNameWhiteList(e, tagify) })
      })
      .catch(err => {
        console.error(err.message)
      })
  })
}

const tagNameWhiteList = (e, tagify) => {
  const value = e.detail.value
  tagify.settings.whitelist.length = 0 // reset current whitelist
  // show loading animation and hide the suggestions dropdown
  tagify.loading(true).dropdown.hide.call(tagify)
  window.fetch(`/tags?tag_name=${value}`)
    .then(response => response.json())
    .then(tagNames => {
      tagify.settings.whitelist.splice(0, tagNames.length, ...tagNames)
      tagify.loading(false).dropdown.show.call(tagify, value) // render the suggestions dropdown
    })
}
