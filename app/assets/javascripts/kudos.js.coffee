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

validateServerSideAndDisplayResults = ->
  author_id          = jQuery("input#author_id").val()
  form_data          = jQuery("form#kudo_send_form").serialize()
  js_validation_flag = encodeURIComponent('kudo[javascript_validation_only]') + "=1"
  jQuery.ajax "/users/" + author_id + "/kudos.js",
      type: "POST"
      data: form_data + "&" + js_validation_flag


scrollScreenToKudo = ->
  kudo_id = jQuery.getQueryString("kudo_id")
  if ((typeof jQuery.getQueryString("recipient") == "string") and (typeof kudo_id == "string"))
    kudo = document.getElementById "kudo_" + kudo_id
    try
       kudo.scrollIntoView(true)
    catch error
       console.log('No kudo to scroll ' + error)

processProviderOnKudosForm  = (provider) ->
  cookieName    = 'check-' + provider + "-share"
  checkboxName  = ".kudo-" + provider + "-share"
  contentCookie = 'kudo-content'

  if OurKudos.Cookies.getCookie(cookieName) is 'yes' and jQuery(checkboxName).attr('data-connected') is 'true'
    jQuery(checkboxName).attr 'checked', 'checked'
    jQuery("#kudo_message_textarea").val(OurKudos.Cookies.getCookie(contentCookie))
    OurKudos.Cookies.deleteCookie cookieName
    OurKudos.Cookies.deleteCookie contentCookie

  jQuery(checkboxName).click ->
    if jQuery(checkboxName).attr('data-connected') is 'false'
        if confirm "It seems that you don't have a " + provider + " account connected yet. Would you like to connect your " + provider + " account with OurKudos now?"
           location.href = location.href.replace("home",'').replace(/users\/\d{1,}\/kudos/,'') +  'users/auth/' + provider
           OurKudos.Cookies.setCookie cookieName,'yes'
           OurKudos.Cookies.setCookie contentCookie,  jQuery("#kudo_message_textarea").val()
           console.log content
        else
           jQuery(checkboxName).removeAttr "checked"

processShareScope = ->
    selectedShare = jQuery("input.share-scope:checked").val()
    if selectedShare is "friends" or selectedShare is "recipient"
        jQuery('#kudo_twitter_sharing').attr "disabled", "disabled"
    if selectedShare is "recipient"
        jQuery('#kudo_facebook_sharing').attr "disabled", "disabled"
    if selectedShare is "on"
        jQuery("#kudo_facebook_sharing").removeAttr "disabled"
        jQuery("#kudo_twitter_sharing").removeAttr "disabled"

checkLastSentForSocial  = (provider) ->
  cookieName    = 'last_sent_with_' + provider
  checkboxName  = ".kudo-" + provider + "-share"

  jQuery(checkboxName).click ->
    if jQuery(checkboxName).attr('data-connected') is 'true'
      checked = jQuery(checkboxName).attr 'checked'
      if checked == true
        OurKudos.Cookies.setCookie cookieName,'yes'
      else
        OurKudos.Cookies.deleteCookie cookieName

jQuery ->
    processProviderOnKudosForm 'facebook'
    processProviderOnKudosForm 'twitter'

    checkLastSentForSocial 'facebook'
    checkLastSentForSocial 'twitter'

    processShareScope()
    scrollScreenToKudo()

    jQuery(".business-card").businessCard()

    jQuery("input.share-scope").click ->
      processShareScope()

    $.Token = jQuery(".kudo_recipient_list")
    $.Token.tokenInput "/autocomplete/new?object=recipients",
        allowCustomEntry: true
        preventDuplicates: true
        onAdd: ->
           validateServerSideAndDisplayResults()

        onDelete: ->
           validateServerSideAndDisplayResults()

    jQuery("select#sort_by").change ->
         jQuery("form#sort_and_search_kudos_form").submit()

