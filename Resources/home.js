(function() {
  var AbstractState, Feed, InitEndState, InitStartState, NormalState, PagingEndState, PagingStartState, PullingState, ReloadEndState, ReloadStartState, actInd, arrow, border, data, lastRow, lastUpdatedLabel, loadingRow, navActInd, state, statusLabel, tableHeader, tableView, transitState, url, user, win;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
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
  navActInd = Ti.UI.createActivityIndicator();
  win.setRightNavButton(navActInd);
  loadingRow = Ti.UI.createTableViewRow({
    title: "更新中…"
  });
  state = null;
  transitState = function(nextState) {
    Ti.API.debug(" -> " + nextState.toString());
    state = nextState;
    return state.execute();
  };
  AbstractState = (function() {
    AbstractState.prototype.toString = function() {
      return 'AbstractState';
    };
    function AbstractState() {}
    AbstractState.prototype.getFeed = function(url) {
      var cb, xhr;
      cb = this.onload;
      xhr = Ti.Network.createHTTPClient();
      xhr.open('GET', url);
      xhr.onload = function() {
        data = JSON.parse(this.responseText);
        return cb(data);
      };
      return xhr.send();
    };
    AbstractState.prototype.onload = function() {};
    AbstractState.prototype.scroll = function(e) {};
    AbstractState.prototype.scrollEnd = function(e) {};
    AbstractState.prototype.execute = function() {};
    return AbstractState;
  })();
  NormalState = (function() {
    __extends(NormalState, AbstractState);
    NormalState.prototype.toString = function() {
      return 'NormalState';
    };
    function NormalState() {
      this.lastDistance = 0;
    }
    NormalState.prototype.scroll = function(e) {
      var distance, height, nearEnd, offset, t, theEnd, total;
      offset = e.contentOffset.y;
      if (offset <= -65.0) {
        t = Ti.UI.create2DMatrix();
        t = t.rotate(-180);
        arrow.animate({
          transform: t,
          duration: 180
        });
        statusLabel.text = "指をはなして更新…";
        return transitState(new PullingState);
      } else {
        height = e.size.height;
        total = offset + height;
        theEnd = e.contentSize.height;
        distance = theEnd - total;
        if (distance < this.lastDistance) {
          nearEnd = theEnd * .75;
          if (total >= nearEnd) {
            transitState(new PagingStartState);
          }
        }
        return this.lastDistance = distance;
      }
    };
    return NormalState;
  })();
  PullingState = (function() {
    __extends(PullingState, AbstractState);
    function PullingState() {
      PullingState.__super__.constructor.apply(this, arguments);
    }
    PullingState.prototype.toString = function() {
      return "PullingState";
    };
    PullingState.prototype.scroll = function(e) {
      var offset, t;
      offset = e.contentOffset.y;
      if (offset > -65.0 && offset < 0) {
        t = Ti.UI.create2DMatrix();
        arrow.animate({
          transform: t,
          duration: 180
        });
        statusLabel.text = "画面を引き下げて…";
        return transitState(new NormalState);
      }
    };
    PullingState.prototype.scrollEnd = function(e) {
      if (e.contentOffset.y <= -65.0) {
        arrow.hide();
        actInd.show();
        statusLabel.text = "読み込み中…";
        tableView.setContentInsets({
          top: 60
        }, {
          animated: true
        });
        arrow.transform = Ti.UI.create2DMatrix();
        return transitState(new ReloadStartState);
      }
    };
    return PullingState;
  })();
  ReloadStartState = (function() {
    __extends(ReloadStartState, AbstractState);
    function ReloadStartState() {
      ReloadStartState.__super__.constructor.apply(this, arguments);
    }
    ReloadStartState.prototype.toString = function() {
      return "ReloadStartState";
    };
    ReloadStartState.prototype.execute = function() {
      return this.getFeed(url);
    };
    ReloadStartState.prototype.onload = function(data) {
      return transitState(new ReloadEndState(data));
    };
    return ReloadStartState;
  })();
  ReloadEndState = (function() {
    __extends(ReloadEndState, AbstractState);
    ReloadEndState.prototype.toString = function() {
      return "ReloadEndState";
    };
    function ReloadEndState(data) {
      this.data = data;
    }
    ReloadEndState.prototype.execute = function() {
      var feed;
      feed = new Feed(this.data);
      tableView.setData(feed.toRows());
      lastRow = feed.size();
      tableView.setContentInsets({
        top: 0
      }, {
        animated: true
      });
      lastUpdatedLabel.text = "最後の更新: ";
      statusLabel.text = "画面を引き下げて…";
      actInd.hide();
      arrow.show();
      return transitState(new NormalState);
    };
    return ReloadEndState;
  })();
  PagingStartState = (function() {
    __extends(PagingStartState, AbstractState);
    function PagingStartState() {
      PagingStartState.__super__.constructor.apply(this, arguments);
    }
    PagingStartState.prototype.toString = function() {
      return "PagingStartState";
    };
    PagingStartState.prototype.execute = function() {
      navActInd.show();
      tableView.appendRow(loadingRow);
      return this.getFeed(url + ("?of=" + lastRow));
    };
    PagingStartState.prototype.onload = function(data) {
      return transitState(new PagingEndState(data));
    };
    return PagingStartState;
  })();
  PagingEndState = (function() {
    __extends(PagingEndState, AbstractState);
    PagingEndState.prototype.toString = function() {
      return "PagingEndState";
    };
    function PagingEndState(data) {
      this.data = data;
    }
    PagingEndState.prototype.execute = function() {
      var feed, rows;
      feed = new Feed(this.data);
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
      navActInd.hide();
      return transitState(new NormalState);
    };
    return PagingEndState;
  })();
  InitStartState = (function() {
    __extends(InitStartState, AbstractState);
    function InitStartState() {
      InitStartState.__super__.constructor.apply(this, arguments);
    }
    InitStartState.prototype.toString = function() {
      return "InitStartState";
    };
    InitStartState.prototype.execute = function() {
      return this.getFeed(url);
    };
    InitStartState.prototype.onload = function(data) {
      return transitState(new InitEndState(data));
    };
    return InitStartState;
  })();
  InitEndState = (function() {
    __extends(InitEndState, AbstractState);
    InitEndState.prototype.toString = function() {
      return "InitEndState";
    };
    function InitEndState(data) {
      this.data = data;
    }
    InitEndState.prototype.execute = function() {
      var feed;
      feed = new Feed(this.data);
      tableView.setData(feed.toRows());
      lastRow = feed.size();
      return transitState(new NormalState);
    };
    return InitEndState;
  })();
  transitState(new InitStartState);
  tableView.addEventListener('scroll', function(e) {
    return state.scroll(e);
  });
  tableView.addEventListener('scrollEnd', function(e) {
    return state.scrollEnd(e);
  });
}).call(this);
