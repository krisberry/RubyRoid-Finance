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
  ), 5000

  $("tbody").find('td').each ()->
    $('.future, .today').mouseenter ()->
      $(this).find('.new-event-hide-button').toggleClass('hidden show')
  $('tbody').find('td').each ()->
    $('.future, .today').mouseleave ()->
      $(this).find('.new-event-hide-button').toggleClass('show hidden')

  ### Activating Best In Place ###

  jQuery('.best_in_place').best_in_place()

  $('.best_in_place').bind "ajax:error", (e, jqXHR) ->
    try
      response = JSON.parse(jqXHR.responseText)
    catch e
      response = [jqXHR.responseText]
    ajax_flash_error(response)

  participant_ids = []

  $('#event_participant_autocomplete').autocomplete
    source: $('#event_participant_autocomplete').data('autocomplete')
    select: (event, ui)->
      unless participant_ids.includes(ui.item.value)
        $('#participant-field')
          .prepend(
            $("<div/>")
              .html($("<label/>").text(ui.item.label))
              .append($("<input type='hidden' name='event[participant_ids][]'/>").val(ui.item.value))
              .append($("<span class='close'/>").attr("data-toggle", "kick").html("&times;"))
          )
        participant_ids.push(ui.item.value)

$(document).on "ready", _custom_func
 
$(document).on 'click', '*[data-toggle="kick"]', (e) ->
  $(this).parent().remove()
