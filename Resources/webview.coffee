win = Ti.UI.currentWindow
webview = Ti.UI.createWebView
  url: win.link

## 要る?
# backButton = Ti.UI.createButton
#   systemButton: Ti.UI.iPhone.SystemButton.REWIND
#
# backButton.addEventListener 'click', (e) ->
#   webview.goBack()
#
# refreshButton = Ti.UI.createButton
#   systemButton: Ti.UI.iPhone.SystemButton.REFRESH
#
# refreshButton.addEventListener 'click', (e) ->
#   webview.reload()
#
# win.toolbar = [ backButton, refreshButton ]

win.add webview