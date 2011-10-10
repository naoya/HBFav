var bookmark, border, entryContainer, favicon, header, link, table, title, titleContainer, url, win, xhr;
require('lib/underscore');
win = Ti.UI.currentWindow;
bookmark = win.bookmark;
link = encodeURI(bookmark.link);
url = "http://b.hatena.ne.jp/entry/jsonlite/?url=" + link;
header = Ti.UI.createView({
  top: 0,
  left: 0,
  width: 320,
  height: 68,
  layout: 'vertical',
  backgroundColor: "stripped"
});
entryContainer = Ti.UI.createView({
  layout: 'vertical',
  width: 310,
  height: 'auto',
  top: 5,
  left: 5,
  bottom: 5
});
titleContainer = Ti.UI.createView({
  layout: 'horizontal',
  width: 300,
  height: 68,
  top: 0,
  left: 0
});
favicon = Ti.UI.createImageView({
  image: bookmark.favicon_url,
  width: 14,
  height: 14,
  top: 2,
  left: 0
});
title = Ti.UI.createLabel({
  color: '#000',
  top: 0,
  left: 4,
  width: 'auto',
  height: 'auto',
  font: {
    fontSize: 13,
    fontWeight: "bold"
  }
});
title.text = bookmark.title;
titleContainer.add(favicon);
titleContainer.add(title);
entryContainer.add(titleContainer);
header.add(entryContainer);
header.addEventListener('click', function() {
  var webView;
  webView = Ti.UI.createWindow({
    url: 'webview.js',
    title: bookmark.title,
    backgroundColor: '#fff',
    link: bookmark.link
  });
  return Ti.UI.currentTab.open(webView);
});
border = Ti.UI.createView({
  backgroundColor: "#ababab",
  top: 68,
  height: 1
});
table = Ti.UI.createTableView({
  top: 69,
  data: []
});
win.add(header);
win.add(border);
win.add(table);
xhr = Ti.Network.createHTTPClient();
xhr.timeout = 100000;
xhr.open('GET', url);
Ti.API.debug(link);
Ti.API.debug(url);
xhr.onerror = function(e) {
  return alert(e.error);
};
xhr.onload = function() {
  var data, rows;
  data = JSON.parse(this.responseText);
  rows = _(data.bookmarks).map(function(b) {
    var bodyContainer, comment, date, image, imageContainer, name, row;
    row = Ti.UI.createTableViewRow({
      height: 'auto',
      layout: 'absolute'
    });
    row.addEventListener('click', function(e) {
      var permalink;
      permalink = Ti.UI.createWindow({
        url: 'permalink.js',
        title: b.user,
        backgroundColor: '#fff',
        bookmark: {
          user: {
            name: b.user,
            profile_image_url: "http://www.st-hatena.com/users/" + b.user.substr(0, 2) + ("/" + b.user + "/profile.gif")
          },
          favicon_url: "http://favicon.st-hatena.com/?url=" + data.entry_url,
          title: data.title,
          count: data.count,
          link: data.url,
          created_at: b.timestamp,
          comment: b.comment
        }
      });
      return Ti.UI.currentTab.open(permalink);
    });
    imageContainer = Ti.UI.createView({
      layout: 'vertical',
      width: 320,
      height: '68',
      top: 0,
      left: 0
    });
    image = Ti.UI.createImageView({
      image: "http://www.st-hatena.com/users/" + b.user.substr(0, 2) + ("/" + b.user + "/profile.gif"),
      width: 48,
      height: 48,
      top: 10,
      left: 10,
      borderRadius: 5
    });
    imageContainer.add(image);
    bodyContainer = Ti.UI.createView({
      layout: 'vertical',
      width: 245,
      height: 'auto',
      left: 65,
      top: 0
    });
    name = Ti.UI.createLabel({
      width: 'auto',
      height: 'auto',
      left: 0,
      top: 10,
      bottom: 5,
      color: '#000',
      font: {
        "font-size": 12,
        fontWeight: 'bold'
      }
    });
    comment = Ti.UI.createLabel({
      color: '#000',
      top: 0,
      left: 0,
      width: 'auto',
      height: 'auto',
      bottom: 10,
      font: {
        "font-size": 14
      }
    });
    date = Ti.UI.createLabel({
      width: 'auto',
      height: 'auto',
      top: 10,
      right: 10,
      color: '#999',
      font: {
        fontSize: 12
      }
    });
    name.text = b.user;
    comment.text = b.comment;
    date.text = b.timestamp.substr(0, 10);
    bodyContainer.add(name);
    bodyContainer.add(comment);
    row.add(imageContainer);
    row.add(bodyContainer);
    row.add(date);
    return row;
  });
  return table.setData(rows);
};
xhr.send();