@printMessage = (message, image_url) ->
  message_box = $('<div class="chat-message"><img class="message-avatar"/><div class="message"></div></div>')
  message_box.find('.message').html($("<span class='message-date'></span>").text($.datepicker.formatDate('dd M yy ', new Date())))
  message_box.find('.message').append($("<span class='message-content'></span>").text message)
  message_box.find('.message-avatar').attr("src", image_url)
  $('.chat-discussion').append(message_box)

$ ->
  $input = $('#chat-input')
  $button = $('#chat-button')
  chatChannel = undefined
  username = undefined
  userimage = undefined

  setupChannel = ->
    chatChannel.join().then (channel) ->
      printMessage(username + ' joined the chat.', userimage)
      return
    chatChannel.on 'messageAdded', (message) ->
      try
        author = JSON.parse(message.author)
      catch
        author = { name: message.author }

      printMessage(author.name + ': ' + message.body, author.image)
      return
    return

  $.post '/tokens', (data) ->
    username = data.username
    userimage = data.userimage
    accessManager = new (Twilio.AccessManager)(data.token)
    messagingClient = new (Twilio.IPMessaging.Client)(accessManager)
    messagingClient.getChannelByUniqueName('chat').then (channel) ->
      if channel
        chatChannel = channel
        setupChannel(userimage)
      else
        messagingClient.createChannel(
          uniqueName: 'chat'
          friendlyName: 'Chat Channel').then (channel) ->
          chatChannel = channel
          setupChannel(userimage)

  $input.on 'keydown', (e) ->
    if e.keyCode == 13
      chatChannel.sendMessage($input.val())
      $input.val ''

  $button.on 'click', (e) ->
    chatChannel.sendMessage($input.val())
    $input.val ''    