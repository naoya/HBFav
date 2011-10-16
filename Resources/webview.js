var actionButton, bookmark, buttonBack, buttonForward, buttonRefresh, countButton, dialog, flexSpace, openBookmarks, readLater, sendToHatena, webview, win;
Ti.include('HatenaBookmark.js');
Ti.include('Instapaper.js');
Ti.include('ui.js');
win = Ti.UI.currentWindow;
bookmark = win.bookmark;
webview = Ti.UI.createWebView({
  url: bookmark.link
});
win.add(webview);
openBookmarks = function() {
  var bookmarksWin;
  bookmarksWin = Ti.UI.createWindow({
    url: 'bookmarks.js',
    title: "" + bookmark.count + " users",
    backgroundColor: "#fff",
    bookmark: bookmark
  });
  return Ti.UI.currentTab.open(bookmarksWin);
};
sendToHatena = function() {
  var entry, msgwin;
  msgwin = HBFav.UI.createMessageWin();
  msgwin.indicator.message = "記事を保存中...";
  msgwin.indicator.show();
  msgwin.open();
  entry = {
    url: bookmark.link,
    comment: ""
  };
  HatenaBookmark.user = {
    id: Ti.App.Properties.getString('hatena_id'),
    password: Ti.App.Properties.getString('hatena_password')
  };
  return HatenaBookmark.post(entry, function() {
    var dialog;
    if (this.status === 201) {
      msgwin.indicator.hide();
      msgwin.label.text = "保存しました";
      return msgwin.close();
    } else {
      msgwin.close();
      dialog = Ti.UI.createAlertDialog({
        title: "Request Failed",
        message: "StatusCode: " + this.status
      });
      return dialog.show();
    }
  });
};
readLater = function() {
  var msgwin;
  msgwin = HBFav.UI.createMessageWin();
  msgwin.indicator.message = "記事を保存中...";
  msgwin.indicator.show();
  msgwin.open();
  Instapaper.user = {
    username: Ti.App.Properties.getString('instapaper_username'),
    password: Ti.App.Properties.getString('instapaper_password')
  };
  return Instapaper.post(webview.url, function() {
    var dialog;
    if (this.status === 201) {
      msgwin.indicator.hide();
      msgwin.label.text = "保存しました";
      return msgwin.close();
    } else {
      msgwin.close();
      dialog = Ti.UI.createAlertDialog({
        title: "Request Failed",
        message: "StatusCode: " + this.status
      });
      return dialog.show();
    }
  });
};
flexSpace = Ti.UI.createButton({
  systemButton: Ti.UI.iPhone.SystemButton.FLEXIBLE_SPACE
});
buttonBack = Ti.UI.createButton({
  title: String.fromCharCode(0x25c0)
});
buttonBack.addEventListener('click', function() {
  return webview.goBack();
});
buttonForward = Ti.UI.createButton({
  title: String.fromCharCode(0x25b6)
});
buttonForward.addEventListener('click', function() {
  return webview.goForward();
});
buttonRefresh = Ti.UI.createButton({
  systemButton: Ti.UI.iPhone.SystemButton.REFRESH
});
buttonRefresh.addEventListener('click', function() {
  return webview.reload();
});
actionButton = Ti.UI.createButton({
  systemButton: Ti.UI.iPhone.SystemButton.ACTION
});
dialog = Ti.UI.createOptionDialog();
dialog.options = ['B!', 'Read Later', 'Safariで開く', 'キャンセル'];
dialog.cancel = dialog.options.length - 1;
dialog.addEventListener('click', function(e) {
  switch (e.index) {
    case 0:
      return sendToHatena();
    case 1:
      return readLater();
    case 2:
      return Ti.Platform.openURL(webview.url);
  }
});
actionButton.addEventListener('click', function() {
  return dialog.show();
});
countButton = Ti.UI.createButton({
  title: "" + bookmark.count + "users",
  style: Ti.UI.iPhone.SystemButtonStyle.BORDERED
});
countButton.addEventListener('click', openBookmarks);
win.toolbar = [buttonBack, flexSpace, buttonForward, flexSpace, buttonRefresh, flexSpace, actionButton, flexSpace, countButton];