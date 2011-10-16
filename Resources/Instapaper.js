var Instapaper;
Instapaper = {};
Instapaper.authenticate = function(callback) {
  var xhr;
  xhr = Ti.Network.createHTTPClient();
  xhr.timeout = 100000;
  xhr.open('POST', 'https://www.instapaper.com/api/authenticate');
  xhr.onload = callback;
  xhr.onerror = function(e) {
    var dialog;
    dialog = Ti.UI.createAlertDialog({
      title: "Ouch!",
      message: "StatusCode: " + this.status
    });
    return dialog.show();
  };
  return xhr.send({
    username: this.user.username,
    password: this.user.password
  });
};
Instapaper.post = function(url, callback) {
  var xhr;
  xhr = Ti.Network.createHTTPClient();
  xhr.timeout = 100000;
  xhr.open('POST', 'https://www.instapaper.com/api/add');
  xhr.onload = callback;
  xhr.onerror = function(e) {
    var dialog;
    dialog = Ti.UI.createAlertDialog({
      title: "Ouch!",
      message: "StatusCode: " + this.status
    });
    return dialog.show();
  };
  return xhr.send({
    username: this.user.username,
    password: this.user.password,
    url: url
  });
};