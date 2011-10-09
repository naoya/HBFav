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
