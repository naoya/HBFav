(function() {
  var button, tab1, tabGroup, user, win;
  Ti.UI.setBackgroundColor('#fff');
  tabGroup = Ti.UI.createTabGroup();
  user = 'naoya';
  win = Ti.UI.createWindow({
    url: 'timeline.js',
    feedUrl: "http://localhost:3000/" + user,
    title: 'タイムライン',
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
