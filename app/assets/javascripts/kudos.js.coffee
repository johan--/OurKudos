# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
OurKudos = Cookies: {}
OurKudos.Cookies =
  setCookie: (name, value, days) ->
    if days
      date = new Date()
      date.setTime date.getTime() + (days * 24 * 60 * 60 * 1000)
      expires = "; expires=" + date.toGMTString()
    else
      expires = ""
    document.cookie = name + "=" + value + expires + "; path=/"

  getCookie: (name) ->
    nameEQ = name + "="
    ca = document.cookie.split(";")
    i = 0

    while i < ca.length
      c = ca[i]
      while c.charAt(0) == " "
        c = c.substring 1, c.length
      if c.indexOf(nameEQ) == 0
        return c.substring(nameEQ.length, c.length)
      i++
    null

  deleteCookie: (name) ->
    @setCookie name, "", -1

processProviderOnKudosForm  = (provider) ->
  cookieName    = 'check-' + provider + "-share"
  checkboxName  = ".kudo-" + provider + "-share"
  if OurKudos.Cookies.getCookie(cookieName) is 'yes' and jQuery(checkboxName).attr('data-connected') is 'true'
    jQuery(checkboxName).attr 'checked', 'checked'
    OurKudos.Cookies.deleteCookie cookieName
  jQuery(checkboxName).click ->
    if jQuery(checkboxName).attr('data-connected') is 'false'
        if confirm "It seems that you don't have a " + provider + " account conneted yet. Would you like to connect your " + provider + " account with OurKudos now?"
           location.href = location.href.replace("home",'') +  'users/auth/' + provider
           OurKudos.Cookies.setCookie cookieName,'yes'
        else
           jQuery(checkboxName).removeAttr "checked"

jQuery ->
  jQuery('.kudo_recipient_list').tokenInput('/autocomplete/new?object=recipients',
          allowCustomEntry: true
    )
    processProviderOnKudosForm 'facebook'
    processProviderOnKudosForm 'twitter'
