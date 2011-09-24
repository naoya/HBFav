Ti.UI.setBackgroundColor '#fff'
tabGroup = Ti.UI.createTabGroup()

win = Ti.UI.createWindow
  url: 'home.js'
  title: 'はてなブックマーク'
  backgroundColor: '#fff'

tab1 = Ti.UI.createTab
  window: win

win.hideTabBar()
tabGroup.addTab tab1
tabGroup.open()