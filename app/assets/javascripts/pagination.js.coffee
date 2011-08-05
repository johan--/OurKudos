loadPage = (pageNo) ->

  kudos = jQuery.getQueryString("kudos")

  if kudos == undefined
    url = "/home?page="
  else
    url = "/home?kudos=" + kudos + "&page="

  jQuery.get url + pageNo, (response) ->
    jQuery("#pagination").remove()
    jQuery("#kudos").append response

jQuery ->
  currPage = 1

  jQuery("a.next_page").live 'click', ->
    loadPage ++currPage

    jQuery(".notice, .alert, .error").remove()

    jQuery("body").click ->
      jQuery(".notice, .alert, .error").remove()

    jQuery("#spinner").show()
    jQuery("#pagination").prepend(' loading more kudos...')

