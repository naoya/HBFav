var image, imageContainer, name, row1, row2, row3, table, user, win;
Ti.include('feedview.js');
win = Ti.UI.currentWindow;
user = win.user;
imageContainer = Ti.UI.createView({
  layout: 'horizontal',
  width: 320,
  height: '68',
  top: 0,
  left: 0,
  backgroundColor: "stripped"
});
image = Ti.UI.createImageView({
  image: user.profile_image_url,
  width: 48,
  height: 48,
  top: 10,
  left: 10,
  borderRadius: 5
});
name = Ti.UI.createLabel({
  width: 'auto',
  height: 48,
  left: 10,
  top: 10,
  color: "#000",
  textAlign: "left",
  font: {
    fontSize: 16,
    fontWeight: 'bold'
  },
  shadowColor: "#fff",
  shadowOffset: {
    x: 0,
    y: 1
  }
});
name.text = user.name;
imageContainer.add(image);
imageContainer.add(name);
table = Ti.UI.createTableView({
  top: 58,
  data: [],
  style: Ti.UI.iPhone.TableViewStyle.GROUPED
});
row1 = Ti.UI.createTableViewRow({
  hasChild: true,
  title: "ブックマーク"
});
row1.addEventListener('click', function() {
  var bookmarkWin, fv;
  bookmarkWin = Ti.UI.createWindow({
    title: user.name
  });
  fv = new FeedView({
    win: bookmarkWin,
    url: "http://localhost:3000/" + user.name + "/bookmark"
  });
  fv.initialize();
  return Ti.UI.currentTab.open(bookmarkWin);
});
row2 = Ti.UI.createTableViewRow({
  hasChild: true,
  title: "フォロー"
});
row2.addEventListener('click', function() {
  var fv, timelineWin;
  timelineWin = Ti.UI.createWindow({
    title: user.name
  });
  fv = new FeedView({
    win: timelineWin,
    url: "http://localhost:3000/" + user.name
  });
  fv.initialize();
  return Ti.UI.currentTab.open(timelineWin);
});
table.appendRow(row1);
table.appendRow(row2);
if (win.showConfig) {
  row3 = Ti.UI.createTableViewRow({
    title: 'アカウント設定',
    header: 'リスト',
    color: '#385487'
  });
  row3.addEventListener('click', function(e) {
    var config;
    config = Ti.UI.createWindow({
      modal: true,
      url: 'config.js',
      title: '設定'
    });
    config.addEventListener('close', function() {
      return win.close();
    });
    return config.open();
  });
  table.appendRow(row3);
}
win.add(imageContainer);
win.add(table);