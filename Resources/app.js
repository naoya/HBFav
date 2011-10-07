(function() {
  var button, tab1, tabGroup, win;
  Ti.UI.setBackgroundColor('#fff');
  tabGroup = Ti.UI.createTabGroup();
  win = Ti.UI.createWindow({
    url: 'home.js',
    title: 'お気に入り',
    backgroundColor: '#fff'
  });
  button = Ti.UI.createButton({
    title: '設定',
    visible: true
  });
  button.addEventListener('click', function(e) {
    var config;
    config = Ti.UI.createWindow({
      modal: true,
      url: 'config.js',
      title: '設定',
      backgroundColor: '#fff'
    });
    return config.open();
  });
  win.setRightNavButton(button);
  tab1 = Ti.UI.createTab({
    window: win
  });
  win.hideTabBar();
  tabGroup.addTab(tab1);
  tabGroup.open();
}).call(this);
