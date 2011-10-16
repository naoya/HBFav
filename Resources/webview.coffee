Ti.include 'HatenaBookmark.js'
Ti.include 'Instapaper.js'
Ti.include 'ui.js'
Ti.include 'util.js'

win = Ti.UI.currentWindow
bookmark = win.bookmark

webview = Ti.UI.createWebView
  url: bookmark.link
win.add webview

## open /entry
openBookmarks = () ->
  bookmarksWin = Ti.UI.createWindow
    url: 'bookmarks.js'
    title: $$$.count2label bookmark.count
    backgroundColor: "#fff"
    bookmark: bookmark
  Ti.UI.currentTab.open bookmarksWin

## save bookmark
sendToHatena = () ->
  msgwin = HBFav.UI.createMessageWin()
  msgwin.indicator.message = "記事を保存中..."
  msgwin.indicator.show()
  msgwin.open()

  entry =
    url: bookmark.link,
    comment: ""

  HatenaBookmark.user =
    id: Ti.App.Properties.getString 'hatena_id'
    password: Ti.App.Properties.getString 'hatena_password'
  HatenaBookmark.post entry, () ->
    if @.status is 201
      msgwin.indicator.hide()
      msgwin.label.text = "保存しました"
      msgwin.close()
    else
      msgwin.close()
      dialog = Ti.UI.createAlertDialog
        title: "Request Failed"
        message: "StatusCode: #{@.status}"
      dialog.show()

openHatenaConfig = ->
  config = Ti.UI.createWindow
    modal: true
    url: 'config.js'
    title: '設定'
  config.open()

readLater = () ->
  msgwin = HBFav.UI.createMessageWin()
  msgwin.indicator.message = "記事を保存中..."
  msgwin.indicator.show()
  msgwin.open()

  Instapaper.user =
    username: Ti.App.Properties.getString 'instapaper_username'
    password: Ti.App.Properties.getString 'instapaper_password'

  Instapaper.post webview.url, () ->
    if @.status is 201
      msgwin.indicator.hide()
      msgwin.label.text = "保存しました"
      msgwin.close()
    else
      msgwin.close()
      dialog = Ti.UI.createAlertDialog
        title: "Request Failed"
        message: "StatusCode: #{@.status}"
      dialog.show()

openInstapaperConfig = ->
  config = Ti.UI.createWindow
    modal: true
    url: 'config_instapaper.js'
    title: 'Instapaper'
  config.open()

flexSpace = Ti.UI.createButton
  systemButton: Ti.UI.iPhone.SystemButton.FLEXIBLE_SPACE

## Toolbar
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

## action
actionButton = Ti.UI.createButton
  systemButton: Ti.UI.iPhone.SystemButton.ACTION

dialog = Ti.UI.createOptionDialog()
dialog.options = [ 'B!', 'Read Later', 'Safariで開く', 'キャンセル' ]
dialog.cancel = dialog.options.length - 1

dialog.addEventListener 'click', (e) ->
  switch e.index
    when 0
      if Ti.App.Properties.getString 'hatena_password'
        sendToHatena()
      else
        openHatenaConfig()
    when 1
      if Ti.App.Properties.getString 'instapaper_username'
        readLater()
      else
        openInstapaperConfig()
    when 2
      Ti.Platform.openURL webview.url

actionButton.addEventListener 'click', ->
  dialog.show()

## to /entry
countButton = Ti.UI.createButton
  title: $$$.count2label bookmark.count
  style: Ti.UI.iPhone.SystemButtonStyle.BORDERED
countButton.addEventListener 'click', openBookmarks

win.toolbar = [ buttonBack, flexSpace, buttonForward, flexSpace, buttonRefresh, flexSpace, actionButton, flexSpace, countButton ]