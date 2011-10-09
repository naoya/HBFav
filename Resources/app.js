(function() {
  var config, initApp;
  Ti.UI.setBackgroundColor('#fff');
  initApp = function() {
    var button, tab1, tabGroup, user, win;
    tabGroup = Ti.UI.createTabGroup();
    user = Ti.App.Properties.getString('hatena_id');
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
        title: '設定'
      });
      return config.open();
    });
    win.setRightNavButton(button);
    tab1 = Ti.UI.createTab({
      window: win
    });
    win.hideTabBar();
    tabGroup.addTab(tab1);
    return tabGroup.open();
  };
  if (!Ti.App.Properties.getString('hatena_id')) {
    config = Ti.UI.createWindow({
      modal: true,
      url: 'config.js',
      title: '初期設定'
    });
    config.open();
  }
  initApp();
}).call(this);
