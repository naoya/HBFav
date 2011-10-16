var HatenaBookmark;
Ti.include('lib/wsse.js');
HatenaBookmark = {};
HatenaBookmark.post = function(entry, callback) {
  var xhr, xml;
  xml = "<entry xmlns=\"http://purl.org/atom/ns#\">\n  <title>dummy</title>\n  <link rel=\"related\" type=\"text/html\" href=\"" + entry.url + "\" />\n  <summary type=\"text/plain\">" + entry.comment + "</summary>\n</entry>";
  xhr = Ti.Network.createHTTPClient();
  xhr.timeout = 100000;
  xhr.open('POST', 'http://b.hatena.ne.jp/atom/post');
  xhr.setRequestHeader('X-WSSE', wsseHeader(this.user.id, this.user.password));
  xhr.onload = callback;
  xhr.onerror = function(e) {
    var dialog;
    dialog = Ti.UI.createAlertDialog({
      title: "Ouch!",
      message: "StatusCode: " + this.status
    });
    return dialog.show();
  };
  return xhr.send(xml);
};