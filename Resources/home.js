(function() {
  var data, tableView, url, user, win, xhr;
  require('lib/underscore');
  win = Ti.UI.currentWindow;
  data = [];
  tableView = Ti.UI.createTableView({
    data: data
  });
  win.add(tableView);
  user = 'naoya';
  url = "http://localhost:3000/" + user;
  xhr = Ti.Network.createHTTPClient();
  xhr.open('GET', url);
  xhr.onload = function() {
    var feed;
    feed = JSON.parse(this.responseText);
    tableView.setData(_(feed.bookmarks).map(function(bookmark) {
      var bodyContainer, comment, date, favicon, image, imageContainer, name, row, title, titleContainer, _ref, _ref2;
      row = Ti.UI.createTableViewRow({
        height: 'auto',
        layout: 'absolute'
      });
      imageContainer = Ti.UI.createView({
        layout: 'vertical',
        width: 320,
        height: '68',
        top: 0,
        left: 0
      });
      image = Ti.UI.createImageView({
        image: bookmark.user.profile_image_url,
        width: 48,
        height: 48,
        top: 10,
        left: 10
      });
      name = Ti.UI.createLabel({
        width: 'auto',
        height: 'auto',
        left: 65,
        top: 10,
        color: "#000",
        font: {
          "font-size": 12,
          fontWeight: 'bold'
        }
      });
      bodyContainer = Ti.UI.createView({
        layout: 'vertical',
        width: 245,
        height: 'auto',
        top: 33,
        left: 65,
        bottom: 10
      });
      comment = Ti.UI.createLabel({
        color: '#000',
        top: 0,
        left: 0,
        width: 'auto',
        height: 'auto',
        bottom: 6,
        font: {
          "font-size": 14
        }
      });
      titleContainer = Ti.UI.createView({
        layout: 'horizontal',
        width: 245,
        height: 'auto',
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
        color: '#3B5998',
        top: 0,
        left: 3,
        width: 'auto',
        height: 'auto',
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
      imageContainer.add(image);
      if (((_ref = bookmark.comment) != null ? _ref.length : void 0) > 0) {
        bodyContainer.add(comment);
      }
      titleContainer.add(favicon);
      titleContainer.add(title);
      bodyContainer.add(titleContainer);
      name.text = bookmark.user.name;
      comment.text = (_ref2 = bookmark.comment) != null ? _ref2 : "";
      title.text = bookmark.title;
      date.text = bookmark.created_at;
      row.add(imageContainer);
      row.add(name);
      row.add(bodyContainer);
      row.add(date);
      return row;
    }));
    return tableView.addEventListener('click', function(e) {
      var bookmark, permalink;
      bookmark = feed.bookmarks[e.index];
      permalink = Ti.UI.createWindow({
        url: 'permalink.js',
        title: bookmark.user.name,
        backgroundColor: '#fff',
        bookmark: bookmark
      });
      return Ti.UI.currentTab.open(permalink);
    });
  };
  xhr.send();
}).call(this);
