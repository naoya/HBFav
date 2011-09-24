(function() {
  var webView, win;
  win = Ti.UI.currentWindow;
  webView = Ti.UI.createWebView({
    url: win.link
  });
  win.add(webView);
}).call(this);
