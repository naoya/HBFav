var actionButton, bookmark, buttonBack, buttonForward, buttonRefresh, countButton, dialog, flexSpace, messageInd, messageLabel, messageView, messageWin, openBookmarks, readLater, sendToHatena, webview, win;
Ti.include('HatenaBookmark.js');
win = Ti.UI.currentWindow;
bookmark = win.bookmark;
webview = Ti.UI.createWebView({
  url: bookmark.link
});
win.add(webview);
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
messageWin = Ti.UI.createWindow({
  height: 40,
  width: 250,
  bottom: 70,
  borderRadius: 10,
  touchEnabled: false
});
messageView = Ti.UI.createView({
  height: 40,
  width: 250,
  borderRadius: 10,
  backgroundColor: '#000',
  opacity: 0.7,
  touchEnabled: false
});
messageLabel = Ti.UI.createLabel({
  text: "",
  color: "#fff",
  width: 250,
  height: 'auto',
  textAlign: 'center',
  font: {
    fontSize: 13
  }
});
messageInd = Ti.UI.createActivityIndicator({
  style: Ti.UI.iPhone.ActivityIndicatorStyle.PLAIN,
  message: '記事を保存中...',
  color: '#fff',
  font: {
    fontSize: 13
  }
});
messageWin.add(messageView);
messageWin.add(messageInd);
messageWin.add(messageLabel);
sendToHatena = function() {
  var entry;
  messageWin.open();
  messageInd.show();
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
      messageInd.hide();
      messageLabel.text = "保存しました";
      return setTimeout(function() {
        return messageWin.close({
          opacity: 0,
          duration: 500
        });
      }, 1000);
    } else {
      messageWin.close();
      dialog = Ti.UI.createAlertDialog({
        title: "Request Failed",
        message: "StatusCode: " + this.status
      });
      return dialog.show();
    }
  });
};
readLater = function() {
  var xhr;
  messageWin.open();
  messageInd.show();
  xhr = Ti.Network.createHTTPClient();
  xhr.timeout = 100000;
  xhr.open('POST', 'https://www.instapaper.com/api/add');
  xhr.onload = function() {
    var dialog;
    if (this.status === 201) {
      messageInd.hide();
      messageLabel.text = "保存しました";
      setTimeout(function() {
        return messageWin.close({
          opacity: 0,
          duration: 500
        });
      }, 1000);
    } else {
      messageWin.close();
      dialog = Ti.UI.createAlertDialog({
        title: "Request Failed",
        message: "StatusCode: " + this.status
      });
      dialog.show();
    }
    xhr.onload = null;
    xhr.onerror = null;
    return xhr = null;
  };
  xhr.onerror = function(e) {
    messageWin.close();
    return alert(e.error);
  };
  return xhr.send({
    username: Ti.App.Properties.getString('instapaper_username'),
    password: Ti.App.Properties.getString('instapaper_password'),
    url: webview.url
  });
};
flexSpace = Ti.UI.createButton({
  systemButton: Ti.UI.iPhone.SystemButton.FLEXIBLE_SPACE
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
win.toolbar = [flexSpace, buttonBack, flexSpace, buttonForward, flexSpace, buttonRefresh, flexSpace, actionButton, flexSpace, countButton];