Instapaper = {}

Instapaper.authenticate = (callback) ->
  xhr = Ti.Network.createHTTPClient()
  xhr.timeout = 100000
  xhr.open 'POST', 'https://www.instapaper.com/api/authenticate'
  xhr.onload = callback
  xhr.onerror = (e) ->
    dialog = Ti.UI.createAlertDialog
      title: "Ouch!"
      message: "StatusCode: #{@.status}"
    dialog.show()
  xhr.send
    username: @user.username
    password: @user.password

Instapaper.post = (url, callback) ->
  xhr = Ti.Network.createHTTPClient()
  xhr.timeout = 100000
  xhr.open 'POST', 'https://www.instapaper.com/api/add'
  xhr.onload = callback
  xhr.onerror = (e) ->
    dialog = Ti.UI.createAlertDialog
      title: "Ouch!"
      message: "StatusCode: #{@.status}"
    dialog.show()
  xhr.send
    username: @user.username
    password: @user.password
    url: url