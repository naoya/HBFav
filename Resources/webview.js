var flexSpace, instapaperButton, messageInd, messageLabel, messageView, messageWin, webview, win;
win = Ti.UI.currentWindow;
webview = Ti.UI.createWebView({
  url: win.link
});
win.add(webview);
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
instapaperButton = Ti.UI.createButton({
  title: 'Read Later',
  visible: true,
  style: Ti.UI.iPhone.SystemButtonStyle.BORDERED
});
instapaperButton.addEventListener('click', function(e) {
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
});
flexSpace = Ti.UI.createButton({
  systemButton: Ti.UI.iPhone.SystemButton.FLEXIBLE_SPACE
});
win.toolbar = [flexSpace, instapaperButton];