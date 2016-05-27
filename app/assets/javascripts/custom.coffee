_custom_func = ->
  $('*[data-toggle="input-datepicker"],.input-datepicker').datepicker({format: "dd/mm/yyyy"})
  $('#event_calculate_amount').click ()->
    $('#event_amount').attr("disabled", $(this).prop("checked"))

  $('#event_add_all_users').click ()->
    if $(this).prop("checked")
      $('#event_participant_ids').attr("disabled", true)
    else
      $('#event_participant_ids').attr("disabled", false)

  $('[data-toggle="tooltip"]').tooltip()

  check_payment = ->
    if $('#event_paid_type_free').prop("checked")
      $('div#disabled_for_free').hide()
    if $('#event_paid_type_custom').prop("checked")
      $('div#disabled_for_free').hide()
    if $('#event_paid_type_paid').prop("checked")
      $('div#disabled_for_free').show()

  check_payment()
  $('#event_paid_type_free, #event_paid_type_paid, #event_paid_type_custom').change ()->
    check_payment()

  setTimeout (->
    $('#flash').remove()
    return
  ), 5000

  $("tbody").find('td').each ()->
    $('.future, .today').mouseenter ()->
      $(this).find('.new-event-hide-button').toggleClass('hidden show')
  $('tbody').find('td').each ()->
    $('.future, .today').mouseleave ()->
      $(this).find('.new-event-hide-button').toggleClass('show hidden')
   
$(document).on "ready", _custom_func
