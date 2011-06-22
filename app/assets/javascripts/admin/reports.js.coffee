jQuery ->
  jQuery("#report_type").change ->
    window.location.href = "/admin/reports/" +  jQuery(this).val()