(function() {
  var webview, win;
  win = Ti.UI.currentWindow;
  webview = Ti.UI.createWebView({
    url: win.link
  });
  win.add(webview);
}).call(this);
