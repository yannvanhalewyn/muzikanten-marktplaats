$(document).on "ready page:load", ->
  ids = []
  $('#add_image_field').fileupload
    add: (e, data) ->
      types = /(\.|\/)(jpe?g|png)$/i
      file = data.files[0]
      if types.test(file.type) || types.test(file.name)
        data.context = $(tmpl("uploaded-image-template", file))
        $('#uploaded-images').append(data.context)
        data.submit()
      else
        alert("#{file.name} is not a jpg or png image")
    progress: (e, data) ->
      console.log('progress')
    done: (e, data) ->
      ids.push(data.result.id)
      $('#img_ids').val(ids)

# $(document).on 'ready page:load', ->

  # # linking to the hidden file input field
  # $("#new_post_attachment label").click ->
    # $('#image_upload').click()
  # ids = []

  # # actually uploading shit
  # $('#image_upload').fileupload
    # url: "/post_attachments/"
    # dataType: 'json'
    # add: (e, data) ->
      # types = /(\.|\/)(jpe?g|png)$/i
      # file = data.files[0]
      # if types.test(file.type) || types.test(file.name)
        # data.context = $(tmpl("template-upload", file))
        # $('#new-images').append(data.context)
        # data.submit()
        # reader = new FileReader()
        # reader.readAsDataURL(file)
        # reader.onloadend = ->
          # console.log(data.context)
          # data.context.css('background-image': 'url(' + this.result + ')')
      # else
        # alert("#{file.name} is not a gif, jpg or png image file")
    # progress: (e, data) ->
      # if data.context
        # progress = parseInt(data.loaded / data.total * 100, 10)
        # data.context.find('.bar').css('width', progress + '%')
    # done: (e, data) ->
      # removeBtn = data.context.find('#remove_photo')
      # console.log(removeBtn)
      # removeBtn.click ->
        # requestDelete data.result.id, ->
          # data.context.hide()
          # ids.splice(ids.indexOf(data.result.id), 1)
          # $('#photos_ids').val(ids)
      # ids.push(data.result.id)
      # console.log(data)
      # $('#photos_ids').val(ids)
      # src = data.result.avatar.small.url

  #$('.delete-button').click ->
    #image_tag = $(this).parent()
    #requestDelete this.dataset.id, ->
      #image_tag.toggle()

#requestDelete = (id, callback) ->
  #$.ajax(
      #url: "/post_attachments/" + id
      #type: 'DELETE',
      #success: callback
  #)



