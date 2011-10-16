Ti.include 'lib/wsse.js'

HatenaBookmark = {}
HatenaBookmark.post = (entry, callback) ->
  xml = """
<entry xmlns="http://purl.org/atom/ns#">
  <title>dummy</title>
  <link rel="related" type="text/html" href="#{entry.url}" />
  <summary type="text/plain">#{entry.comment}</summary>
</entry>
"""

  xhr = Ti.Network.createHTTPClient()
  xhr.timeout = 100000
  xhr.open 'POST', 'http://b.hatena.ne.jp/atom/post'
  xhr.setRequestHeader 'X-WSSE', wsseHeader(@user.id, @user.password)

  # Ti.API.debug wsseHeader(@user.id, @user.password)

  xhr.onload = callback
  xhr.onerror = (e) ->
    dialog = Ti.UI.createAlertDialog
      title: "Ouch!"
      message: "StatusCode: #{@.status}"
    dialog.show()
  xhr.send xml