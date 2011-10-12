var tab1, tabGroup, win;
Ti.App.config = {
  serverRoot: 'http://hbfav.herokuapp.com'
};
Ti.API.debug("serverRoot: " + Ti.App.config.serverRoot);
Ti.UI.setBackgroundColor('#fff');
win = Ti.UI.createWindow({
  url: 'timeline.js',
  title: 'タイムライン',
  backgroundColor: '#fff'
});
tab1 = Ti.UI.createTab({
  window: win
});
win.hideTabBar();
tabGroup = Ti.UI.createTabGroup();
tabGroup.addTab(tab1);
tabGroup.open();