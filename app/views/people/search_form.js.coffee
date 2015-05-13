search_form = "<%= escape_javascript(render(:partial => 'search_form')) %>"
$('#search').html(search_form)
$('#search-select').change ->
  $.ajax({
    type: "POST",
    url: "<%= search_people_path %>",
    data: { termr: $('#search-select').val() },
    success:(data) ->
      return false
    error:(data) ->
      comms_error(data)
      return false
  })
comms_error = (data) ->
  alert("error")