Ti.include 'HatenaBookmark.js'

win = Ti.UI.currentWindow
bookmark = win.bookmark

webview = Ti.UI.createWebView
  url: bookmark.link
win.add webview

## buttonBack
buttonBack = Ti.UI.createButton
  title: String.fromCharCode(0x25c0)
buttonBack.addEventListener 'click', ->
  webview.goBack()

buttonForward = Ti.UI.createButton
  title: String.fromCharCode(0x25b6)
buttonForward.addEventListener 'click', ->
  webview.goForward()

buttonRefresh = Ti.UI.createButton
  systemButton: Ti.UI.iPhone.SystemButton.REFRESH
buttonRefresh.addEventListener 'click', ->
  webview.reload()

## open /entry
openBookmarks = () ->
  bookmarksWin = Ti.UI.createWindow
    url: 'bookmarks.js'
    title: "#{bookmark.count} users"
    backgroundColor: "#fff"
    bookmark: bookmark
  Ti.UI.currentTab.open bookmarksWin

## InstaPaper
messageWin = Ti.UI.createWindow
  height: 40
  width: 250
  bottom: 70
  borderRadius: 10
  touchEnabled: false

messageView = Ti.UI.createView
  height: 40
  width: 250
  borderRadius: 10
  backgroundColor: '#000'
  opacity: 0.7
  touchEnabled: false

messageLabel = Ti.UI.createLabel
  text: ""
  color: "#fff"
  width: 250
  height: 'auto'
  textAlign: 'center'
  font:
    fontSize: 13

messageInd = Ti.UI.createActivityIndicator
  style: Ti.UI.iPhone.ActivityIndicatorStyle.PLAIN
  message: '記事を保存中...'
  color: '#fff'
  font:
    fontSize: 13

messageWin.add messageView
messageWin.add messageInd
messageWin.add messageLabel

## save bookmark
sendToHatena = () ->
  messageWin.open()
  messageInd.show()

  entry =
    url: bookmark.link,
    comment: ""

  HatenaBookmark.user =
    id: Ti.App.Properties.getString 'hatena_id'
    password: Ti.App.Properties.getString 'hatena_password'
  HatenaBookmark.post entry, () ->
    if @.status is 201
      messageInd.hide()
      messageLabel.text = "保存しました"
      setTimeout ->
        messageWin.close
          opacity: 0
          duration: 500
      ,1000
    else
      messageWin.close()
      dialog = Ti.UI.createAlertDialog
        title: "Request Failed"
        message: "StatusCode: #{@.status}"
      dialog.show()

readLater = () ->
  messageWin.open()
  messageInd.show()

  xhr = Ti.Network.createHTTPClient()
  xhr.timeout = 100000
  xhr.open 'POST', 'https://www.instapaper.com/api/add'
  xhr.onload = ->
    if @.status is 201
      messageInd.hide()
      messageLabel.text = "保存しました"
      setTimeout ->
        messageWin.close
          opacity: 0
          duration: 500
      ,1000
    else
      messageWin.close()
      dialog = Ti.UI.createAlertDialog
        title: "Request Failed"
        message: "StatusCode: #{@.status}"
      dialog.show()

    xhr.onload = null
    xhr.onerror = null
    xhr = null

  xhr.onerror = (e) ->
    messageWin.close()
    alert e.error

  xhr.send
    username: Ti.App.Properties.getString 'instapaper_username'
    password: Ti.App.Properties.getString 'instapaper_password'
    url: webview.url

flexSpace = Ti.UI.createButton
  systemButton: Ti.UI.iPhone.SystemButton.FLEXIBLE_SPACE

## action
actionButton = Ti.UI.createButton
  systemButton: Ti.UI.iPhone.SystemButton.ACTION

dialog = Ti.UI.createOptionDialog()
dialog.options = [ 'B!', 'Read Later', 'Safariで開く', 'キャンセル' ]
dialog.cancel = dialog.options.length - 1

dialog.addEventListener 'click', (e) ->
  switch e.index
    when 0
      sendToHatena()
    when 1
      readLater()
    when 2
      Ti.Platform.openURL webview.url
#    when 2
#      Ti.UI.Clipboard.setText webview.url

actionButton.addEventListener 'click', ->
  dialog.show()

## to /entry
countButton = Ti.UI.createButton
  title: "#{bookmark.count}users"
  style: Ti.UI.iPhone.SystemButtonStyle.BORDERED
countButton.addEventListener 'click', openBookmarks

# win.setRightNavButton countButton
# win.toolbar = [ instapaperButton, flexSpace, actionButton ]
win.toolbar = [ flexSpace, buttonBack, flexSpace, buttonForward, flexSpace, buttonRefresh, flexSpace, actionButton, flexSpace, countButton ]
# win.setRightNavButton actionButton
