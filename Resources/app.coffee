Ti.App.config =
  serverRoot: 'http://hbfav.herokuapp.com'
  # serverRoot: 'http://localhost:3000'
  # serverRoot: 'http://192.168.11.6:3000'

Ti.API.debug "serverRoot: #{Ti.App.config.serverRoot}"

Ti.UI.setBackgroundColor '#fff'

win = Ti.UI.createWindow
  url: 'timeline.js'
  title: 'タイムライン'
  backgroundColor: '#fff'

tab1 = Ti.UI.createTab
  window: win
win.hideTabBar()
tabGroup = Ti.UI.createTabGroup()
tabGroup.addTab tab1
tabGroup.open()
