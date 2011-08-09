loadPage = (pageNo) ->

  kudos   = jQuery.getQueryString("kudos")
  sort_by = jQuery.getQueryString("sort_by")

  sort_by = '' if sort_by is undefined

  if kudos == undefined
    url = "/home.js?page=" + pageNo + "&sort_by=" + sort_by
  else
    url = "/home.js?kudos=" + kudos + "&page=" + pageNo + "&sort_by=" + sort_by

  jQuery.get url, (response) ->
    jQuery("#pagination").remove()
    jQuery("div#kudos").append response

jQuery ->
  currPage = 1

  jQuery("a.next_page").live 'click', ->
    loadPage ++currPage

    jQuery(".notice, .alert, .error").remove()

    jQuery("body").click ->
      jQuery(".notice, .alert, .error").remove()

    jQuery("#spinner").show()
    jQuery("#pagination").prepend 'loading more kudos...'

