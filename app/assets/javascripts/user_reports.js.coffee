# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

updateSummary = (x) ->
  $.ajax document.URL + '/update_summary',
    type: 'PATCH'
    data: { summary: $('#summary').val() }

$('#summary').keyup(_.debounce(updateSummary, 500))

updateFee = (event) ->
  feeId = $(event.target).data('fee-id')
  $.ajax document.URL + '/update_fee',
  type: 'PATCH',
  data: {
    fee_id: feeId
    comment:  $('#comment_fee_' + feeId).text()
    currency: $('#currency_fee_' + feeId).text()
    sum:      $('#sum_fee_' + feeId).text() }

$('div[data-fee-id]').keyup(_.debounce(updateFee, 500))
