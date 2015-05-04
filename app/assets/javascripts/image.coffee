$(document).on "ready page:load", ->
  $('#new_image').fileupload ->
    add: ->
      alert('add')
