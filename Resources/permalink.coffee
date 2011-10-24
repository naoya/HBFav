Ti.include 'feedview.js'
Ti.include 'ui.js'
Ti.include 'util.js'

win = Ti.UI.currentWindow
# win.layout = 'vertical'
bookmark = win.bookmark

scrollView = Ti.UI.createScrollView
  contentWidth: 320
  contentHeight: 'auto'
  top:0
  bottom: 0
  showHorizontalScrollIndicator: true

view = Ti.UI.createView
  top: 0
  left: 0
  width: 'auto'
  height: 'auto'
  layout: 'absolute'
  backgroundColor: "#fff"

scrollView.add view
win.add scrollView

imageContainer = Ti.UI.createView
  layout: 'vertical'
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
# image.imageWithCache bookmark.user.profile_image_url
image.imageWithCache $$$.profileImageUrlLarge bookmark.user.name

name = Ti.UI.createLabel
  width: 'auto'
  height: 48
  left: 65
  top: 10
  color: "#000"
  font:
    fontSize : 18
    fontWeight: 'bold'
  shadowColor: "#fff"
  shadowOffset: x: 0, y: 1
  backgroundColor: "transparent"

border = Ti.UI.createView
  backgroundColor: "#ababab"
  top: 68
  height: 1

bodyContainer = Ti.UI.createView
  layout: 'vertical'
  width: 300
  height: 'auto'
  top: 78
  left: 10

comment = Ti.UI.createLabel
  color: '#000'
  backgroundColor: '#fff'
  top: 0
  left: 0
  width: 'auto'
  height: 'auto'
  bottom: 10
  font:
    fontSize: 18

titleContainer = Ti.UI.createView
  layout: 'horizontal'
  width: 'auto'
  height: 'auto'
  top: 0
  left: 0

favicon = HBFav.UI.createImageView
  width: 16
  height: 16
  top: 2
  left: 0
favicon.imageWithCache bookmark.favicon_url

title = Ti.UI.createLabel
  color: '#3B5998'
  backgroundColor: '#fff'
  top: 0
  left: 3
  width: 'auto'
  height: 'auto'
  font:
    fontSize: 18

link = Ti.UI.createLabel
  color: '#666'
  backgroundColor: '#fff'
  width: 'auto'
  height: 'auto'
  top: 4
  left: 19
  font:
    fontSize: 14

footerContainer = Ti.UI.createView
  layout: 'horizontal'
  width: 'auto'
  height: 'auto'
  top: 3
  left: 0

date = Ti.UI.createLabel
  width: 'auto'
  height: 'auto'
  backgroundColor: '#fff'
  top: 0
  left: 20
  bottom: 10
  color: '#666'
  font:
    fontSize: 13

# count = Ti.UI.createLabel
#   width: 'auto'
#   height: 'auto'
#   top: 0
#   left: 0
#   color: '#999'
#   font:
#     fontSize: 14

imageContainer.add image

if bookmark.comment?.length > 0
  bodyContainer.add comment
titleContainer.add favicon
titleContainer.add title
bodyContainer.add titleContainer
bodyContainer.add link
footerContainer.add date
bodyContainer.add footerContainer

name.text    = bookmark.user.name
comment.text = bookmark.comment ? ""
title.text   = bookmark.title
link.text    = bookmark.link
date.text    = bookmark.created_at

win.add imageContainer
win.add name
win.add border

view.add bodyContainer

## xx users navigation
button = Ti.UI.createButton
  title: $$$.count2label bookmark.count
  backgroundColor: '#fff'
  height: 40
  width: 300
  top: 10
  bottom: 20
  textAlign: "left"

button.addEventListener 'click', (e) ->
  bookmarksWin = Ti.UI.createWindow
    url: 'bookmarks.js'
    title: $$$.count2label bookmark.count
    backgroundColor: "#fff"
    bookmark: bookmark
    bottom: 10
  Ti.UI.currentTab.open bookmarksWin

# win.add button
bodyContainer.add button

imageContainer.addEventListener 'click', ->
  profile = Ti.UI.createWindow
    url: 'profile.js'
    title: bookmark.user.name
    user: bookmark.user
  Ti.UI.currentTab.open profile

titleContainer.addEventListener 'click', ->
  webView = Ti.UI.createWindow
    url: 'webview.js'
    title: bookmark.title
    backgroundColor: '#fff'
    bookmark: bookmark
  Ti.UI.currentTab.open webView