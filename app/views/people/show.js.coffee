person = "<%= escape_javascript(render(:partial => 'person', locals: {person: @person})) %>"
$('#person').html(person)
