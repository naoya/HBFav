Ti.App.config =
  serverRoot: 'http://localhost:3000'

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
