Ti.include 'feedview.js'
Ti.include 'ui.js'
win = Ti.UI.currentWindow
user = win.user

imageContainer = Ti.UI.createView
  layout: 'horizontal'
  width: 320
  height: '68'
  top: 0
  left: 0
  backgroundColor: "stripped"

image = HBFav.UI.createImageView
  width: 48
  height: 48
  top: 10
  left: 10
  borderRadius: 5
image.imageWithCache user.profile_image_url

name = Ti.UI.createLabel
  width: 'auto'
  height: 48
  left: 10
  top: 10
  color: "#000"
  textAlign: "left"
  font:
    fontSize : 18
    fontWeight: 'bold'
  shadowColor: "#fff"
  shadowOffset: x: 0, y: 1
name.text = user.name

imageContainer.add image
imageContainer.add name

## ボタン配置
sections = []
section1 = Ti.UI.createTableViewSection()

row1 = Ti.UI.createTableViewRow
  hasChild: true
  title: "ブックマーク"

row1.addEventListener 'click', ->
  bookmarkWin = Ti.UI.createWindow
    title: user.name
  fv = new FeedView
    win: bookmarkWin
    url: Ti.App.config.serverRoot + "/#{user.name}/bookmark"
  fv.initialize()
  Ti.UI.currentTab.open bookmarkWin

row2 = Ti.UI.createTableViewRow
  hasChild: true
  title: "フォロー"

row2.addEventListener 'click', ->
  timelineWin = Ti.UI.createWindow
    title: user.name
  fv = new FeedView
    win: timelineWin
    url: Ti.App.config.serverRoot + "/#{user.name}"
  fv.initialize()
  Ti.UI.currentTab.open timelineWin

section1.add row1
section1.add row2
sections.push section1

if win.showConfig
  section2 = Ti.UI.createTableViewSection
    visible: true
    headerTitle: '設定'

  row3 = Ti.UI.createTableViewRow
    title: 'はてなID'
    # header: '設定'
    color: '#385487'

  row3.addEventListener 'click', (e) ->
    config = Ti.UI.createWindow
      modal: true
      url: 'config.js'
      title: '設定'
    config.addEventListener 'close', () ->
      if user.name isnt Ti.App.Properties.getString 'hatena_id'
        win.close()
    config.open()

  row4 = Ti.UI.createTableViewRow
    title: 'Instapaper'
    color: '#385487'

  row4.addEventListener 'click', (e) ->
    instapaper = Ti.UI.createWindow
      modal: true
      url: 'config_instapaper.js'
      title: 'Instapaper'
    instapaper.open()

  # table.appendRow row3
  # table.insertRowAfter 2, row4 # もっとましな挿入方法ないの?
  # table.appendRow row4
  # table.add section2

  section2.add row3
  section2.add row4
  sections.push section2

table = Ti.UI.createTableView
  top: 58
  data: sections
  style: Ti.UI.iPhone.TableViewStyle.GROUPED

win.add imageContainer
win.add table