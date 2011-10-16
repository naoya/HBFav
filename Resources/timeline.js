var config, fv, initApp, win;
Ti.include('feedview.js');
win = Ti.UI.currentWindow;
fv = new FeedView({
  win: win
});
initApp = function() {
  var icon, user;
  user = Ti.App.Properties.getString('hatena_id');
  icon = Ti.UI.createButton({
    systemButton: Ti.UI.iPhone.SystemButton.BOOKMARKS,
    style: Ti.UI.iPhone.SystemButtonStyle.PLAIN,
    visible: true
  });
  icon.addEventListener('click', function() {
    var profile;
    profile = Ti.UI.createWindow({
      url: 'profile.js',
      title: user,
      showConfig: true,
      user: {
        name: user,
        profile_image_url: $$$.profileImageUrl(user)
      }
    });
    profile.addEventListener('close', function() {
      if (user !== Ti.App.Properties.getString('hatena_id')) {
        return initApp();
      }
    });
    return Ti.UI.currentTab.open(profile);
  });
  win.setRightNavButton(icon);
  fv.url = Ti.App.config.serverRoot + ("/" + user);
  if (fv.lastRow > 0) {
    fv.clear();
  }
  return fv.initialize();
};
if (Ti.App.Properties.getString('hatena_id')) {
  initApp();
} else {
  config = Ti.UI.createWindow({
    modal: true,
    url: 'config.js',
    title: '初期設定'
  });
  config.addEventListener('close', initApp);
  config.open();
}