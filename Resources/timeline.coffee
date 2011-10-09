Ti.include 'feedview.js'

win = Ti.UI.currentWindow
fv = new FeedView
  win: win

initApp = ()->
  user = Ti.App.Properties.getString 'hatena_id'
  fv.url = "http://localhost:3000/#{user}"
  if fv.lastRow > 0
    fv.clear()
  fv.initialize()

button = Ti.UI.createButton
  title: '設定'
  visible: true

button.addEventListener 'click', (e) ->
  config = Ti.UI.createWindow
    modal: true
    url: 'config.js'
    title: '設定'
  config.addEventListener 'close', initApp
  config.open()

win.setRightNavButton button

if Ti.App.Properties.getString 'hatena_id'
  initApp()
else
  config = Ti.UI.createWindow
    modal: true
    url: 'config.js'
    title: '初期設定'
  config.open()
