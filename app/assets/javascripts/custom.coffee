@ajax_flash_error = (messages) ->
  $.each messages, (i, val) ->
    $("#flash")
      .html(
        $("<div/>").addClass("alert alert-danger alert-dismissible").attr("role", "alert")
        .append(
          $("<button/>").addClass("close").attr(type: "button", 'data-dismiss': "alert", 'aria-label': "Close")
          .html(
            $("<span/>").attr("aria-hidden", "true").html("&times;")
          )
        ).append(val)
      )

_custom_func = ->
  $('*[data-toggle="input-datepicker"],.input-datepicker').datepicker({format: "dd/mm/yyyy"})
  $('#event_calculate_amount').click ()->
    $('#event_amount').attr("disabled", $(this).prop("checked"))

  $('#event_add_all_users').click ()->
    $('#event_participant_ids').attr("disabled", $(this).prop("checked"))
    $('.js-example-basic-multiple').select2("destroy")
    $('.js-example-basic-multiple').select2(tags: true)

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
  ), 5000

  $('#calendar .future, #calendar .today').mouseenter ()->
    $(this).find('.new-event-hide-button').toggleClass('hidden show')
  $('#calendar .future, #calendar .today').mouseleave ()->
    $(this).find('.new-event-hide-button').toggleClass('show hidden')

  ### Activating Best In Place ###

  jQuery('.best_in_place').best_in_place()

  $('.best_in_place').bind "ajax:error", (e, jqXHR) ->
    try
      response = JSON.parse(jqXHR.responseText)
    catch e
      response = [jqXHR.responseText]
    ajax_flash_error(response)

  $('.js-example-basic-multiple').select2({
    tags: true
  })

$(document).on "ready", _custom_func

