var bookmark, bookmarks2rows, border, entryContainer, favicon, header, ind, link, loadingRow, table, title, titleContainer, url, win, xhr;
require('lib/underscore');
Ti.include('ui.js');
Ti.include('util.js');
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
favicon = HBFav.UI.createImageView({
  width: 14,
  height: 14,
  top: 2,
  left: 0
});
favicon.imageWithCache(bookmark.favicon_url);
title = Ti.UI.createLabel({
  color: '#000',
  top: 0,
  left: 4,
  width: 'auto',
  height: 'auto',
  font: {
    fontSize: 13,
    fontWeight: "bold"
  },
  backgroundColor: 'transparent'
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
    bookmark: bookmark
  });
  return Ti.UI.currentTab.open(webView);
});
border = Ti.UI.createView({
  backgroundColor: "#ababab",
  top: 68,
  height: 1
});
loadingRow = Ti.UI.createTableViewRow();
ind = Ti.UI.createActivityIndicator({
  top: 10,
  bottom: 10,
  style: Ti.UI.iPhone.ActivityIndicatorStyle.DARK
});
ind.show();
loadingRow.add(ind);
table = Ti.UI.createTableView({
  top: 69,
  data: [loadingRow]
});
table.addEventListener('click', function(e) {
  var row;
  row = e.rowData;
  if (row.bookmark) {
    return Ti.UI.currentTab.open(Ti.UI.createWindow({
      url: 'permalink.js',
      title: 'ブックマーク',
      bookmark: row.bookmark
    }));
  }
});
win.add(header);
win.add(border);
win.add(table);
bookmarks2rows = function(data, start, end) {
  var bookmarks, rows;
  bookmarks = data.bookmarks.slice(start, end);
  rows = _(bookmarks).map(function(b) {
    var bodyContainer, comment, date, image, imageContainer, name, row, _ref;
    row = Ti.UI.createTableViewRow({
      height: 'auto',
      layout: 'absolute',
      bookmark: {
        user: {
          name: b.user,
          profile_image_url: $$$.profileImageUrlLarge(b.user)
        },
        favicon_url: "http://favicon.st-hatena.com/?url=" + data.url,
        title: data.title,
        count: data.count,
        link: data.url,
        created_at: b.timestamp,
        comment: b.comment
      }
    });
    imageContainer = Ti.UI.createView($$.timeline.profileImageContainer);
    image = HBFav.UI.createImageView($$.timeline.profileImage);
    image.imageWithCache($$$.profileImageUrlLarge(b.user));
    imageContainer.add(image);
    bodyContainer = Ti.UI.createView($$.timeline.bodyContainer);
    name = Ti.UI.createLabel(_($$.timeline.nameLabel).extend({
      text: b.user
    }));
    date = Ti.UI.createLabel(_($$.timeline.dateLabel).extend({
      text: (_ref = b.timestamp) != null ? _ref.substr(0, 10) : void 0
    }));
    bodyContainer.add(name);
    if (b.comment.length > 0) {
      comment = Ti.UI.createLabel(_($$.timeline.commentLabel).extend({
        text: b.comment
      }));
      bodyContainer.add(comment);
    }
    row.add(imageContainer);
    row.add(bodyContainer);
    row.add(date);
    return row;
  });
  return rows;
};
xhr = Ti.Network.createHTTPClient();
xhr.timeout = 100000;
xhr.open('GET', url);
Ti.API.debug(link);
Ti.API.debug(url);
xhr.onerror = function(e) {
  return alert(e.error);
};
xhr.onload = function() {
  var data, setData;
  data = JSON.parse(this.responseText);
  setData = function(offset, limit) {
    var current, label, more, rows, section;
    rows = bookmarks2rows(data, offset, offset + limit);
    section = Ti.UI.createTableViewSection();
    _(rows).each(function(row) {
      return section.add(row);
    });
    if (rows.length === limit) {
      more = Ti.UI.createTableViewRow();
      label = Ti.UI.createLabel({
        text: "もっと見る",
        color: "#194C7F",
        textAlign: "center",
        font: {
          fontSize: 16,
          fontWeight: "bold"
        }
      });
      more.add(label);
      more.addEventListener('click', function(e) {
        var loadingInd;
        loadingInd = Ti.UI.createActivityIndicator({
          top: 10,
          bottom: 10,
          style: Ti.UI.iPhone.ActivityIndicatorStyle.DARK
        });
        loadingInd.show();
        more.remove(label);
        more.add(loadingInd);
        offset += limit;
        return setData(offset, limit);
      });
      section.add(more);
    }
    if (offset === 0) {
      table.deleteRow(offset, {
        animationStyle: Ti.UI.iPhone.RowAnimationStyle.NONE
      });
    }
    current = table.data;
    current.push(section);
    table.setData(current);
    if (offset !== 0) {
      return table.deleteRow(offset, {
        animationStyle: Ti.UI.iPhone.RowAnimationStyle.NONE
      });
    }
  };
  setData(0, 50);
  xhr.onload = null;
  xhr.onerror = null;
  return xhr = null;
};
xhr.send();