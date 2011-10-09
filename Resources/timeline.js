var button, config, fv, initApp, win;
Ti.include('feedview.js');
win = Ti.UI.currentWindow;
fv = new FeedView({
  win: win
});
initApp = function() {
  var user;
  user = Ti.App.Properties.getString('hatena_id');
  fv.url = "http://localhost:3000/" + user;
  if (fv.lastRow > 0) {
    fv.clear();
  }
  return fv.initialize();
};
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
  config.addEventListener('close', initApp);
  return config.open();
});
win.setRightNavButton(button);
if (Ti.App.Properties.getString('hatena_id')) {
  initApp();
} else {
  config = Ti.UI.createWindow({
    modal: true,
    url: 'config.js',
    title: '初期設定'
  });
  config.open();
}