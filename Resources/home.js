(function() {
  var Feed, actInd, arrow, beginReloading, beginUpdate, border, data, endReloading, endUpdate, lastDistance, lastRow, lastUpdatedLabel, loadingRow, navActInd, pulling, reloading, statusLabel, tableHeader, tableView, updateTimeline, updating, url, user, win, xhr;
  require('lib/underscore');
  Feed = require('feed').Feed;
  user = 'naoya';
  url = "http://localhost:3000/" + user;
  lastRow = 0;
  win = Ti.UI.currentWindow;
  data = [];
  tableView = Ti.UI.createTableView({
    data: data
  });
  win.add(tableView);
  updateTimeline = function(feed) {
    tableView.setData(feed.toRows());
    return lastRow = feed.size();
  };
  xhr = Ti.Network.createHTTPClient();
  xhr.open('GET', url);
  xhr.onload = function() {
    data = JSON.parse(this.responseText);
    return updateTimeline(new Feed(data));
  };
  xhr.send();
  border = Ti.UI.createView({
    backgroundColor: "#576c89",
    height: 2,
    bottom: 0
  });
  tableHeader = Ti.UI.createView({
    backgroundColor: "#e2e7ed",
    width: 320,
    height: 60
  });
  tableHeader.add(border);
  arrow = Ti.UI.createView({
    backgroundImage: "./images/whiteArrow.png",
    width: 23,
    height: 60,
    bottom: 10,
    left: 20
  });
  statusLabel = Ti.UI.createLabel({
    text: "画面を引き下げて…",
    left: 55,
    width: 200,
    bottom: 30,
    height: "auto",
    color: "#576c89",
    textAlign: "center",
    font: {
      fontSize: 12,
      fontWeight: "bold"
    },
    shadowColor: "#999",
    shadowOffset: {
      x: 0,
      y: 1
    }
  });
  lastUpdatedLabel = Ti.UI.createLabel({
    text: "最後の更新: ",
    left: 55,
    width: 200,
    bottom: 15,
    height: "auto",
    color: "#576c89",
    textAlign: "center",
    font: {
      fontSize: 11
    },
    shadowColor: "#999",
    shadowOffset: {
      x: 0,
      y: 1
    }
  });
  actInd = Titanium.UI.createActivityIndicator({
    left: 20,
    bottom: 13,
    width: 30,
    height: 30
  });
  tableHeader.add(arrow);
  tableHeader.add(statusLabel);
  tableHeader.add(lastUpdatedLabel);
  tableHeader.add(actInd);
  tableView.headerPullView = tableHeader;
  pulling = false;
  reloading = false;
  beginReloading = function() {
    xhr = Ti.Network.createHTTPClient();
    xhr.open('GET', url);
    xhr.onload = function() {
      data = JSON.parse(this.responseText);
      return endReloading(new Feed(data));
    };
    return xhr.send();
  };
  endReloading = function(feed) {
    updateTimeline(feed);
    tableView.setContentInsets({
      top: 0
    }, {
      animated: true
    });
    reloading = false;
    lastUpdatedLabel.text = "最後の更新: ";
    statusLabel.text = "画面を引き下げて…";
    actInd.hide();
    return arrow.show();
  };
  tableView.addEventListener('scroll', function(e) {
    var offset, t;
    offset = e.contentOffset.y;
    if (offset <= -65.0 && !pulling) {
      t = Ti.UI.create2DMatrix();
      t = t.rotate(-180);
      pulling = true;
      arrow.animate({
        transform: t,
        duration: 180
      });
      return statusLabel.text = "指をはなして更新…";
    } else if (pulling && offset > -65.0 && offset < 0) {
      pulling = false;
      t = Ti.UI.create2DMatrix();
      arrow.animate({
        transform: t,
        duration: 180
      });
      return statusLabel.text = "画面を引き下げて…";
    }
  });
  tableView.addEventListener('scrollEnd', function(e) {
    if (pulling && !reloading && e.contentOffset.y <= -65.0) {
      reloading = true;
      pulling = false;
      arrow.hide();
      actInd.show();
      statusLabel.text = "読み込み中…";
      tableView.setContentInsets({
        top: 60
      }, {
        animated: true
      });
      arrow.transform = Ti.UI.create2DMatrix();
      return beginReloading();
    }
  });
  navActInd = Ti.UI.createActivityIndicator();
  win.setRightNavButton(navActInd);
  updating = false;
  loadingRow = Ti.UI.createTableViewRow({
    title: "更新中…"
  });
  beginUpdate = function() {
    updating = true;
    navActInd.show();
    tableView.appendRow(loadingRow);
    xhr = Ti.Network.createHTTPClient();
    xhr.open('GET', url + ("?of=" + lastRow));
    xhr.onload = function() {
      data = JSON.parse(this.responseText);
      return endUpdate(new Feed(data));
    };
    return xhr.send();
  };
  endUpdate = function(feed) {
    var rows;
    updating = false;
    tableView.deleteRow(lastRow, {
      animationStyle: Ti.UI.iPhone.RowAnimationStyle.NONE
    });
    rows = feed.toRows();
    _(rows).each(function(row) {
      return tableView.appendRow(row, {
        animationStyle: Ti.UI.iPhone.RowAnimationStyle.NONE
      });
    });
    lastRow += feed.size();
    return navActInd.hide();
  };
  lastDistance = 0;
  tableView.addEventListener('scroll', function(e) {
    var distance, height, nearEnd, offset, theEnd, total;
    offset = e.contentOffset.y;
    height = e.size.height;
    total = offset + height;
    theEnd = e.contentSize.height;
    distance = theEnd - total;
    if (distance < lastDistance) {
      nearEnd = theEnd * .75;
      if (!updating && (total >= nearEnd)) {
        beginUpdate();
      }
    }
    return lastDistance = distance;
  });
}).call(this);
