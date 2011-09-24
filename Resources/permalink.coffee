win = Ti.UI.currentWindow
bookmark = win.bookmark

view = Ti.UI.createView
  top: 0
  left: 0
  width: 'auto'
  height: 'auto'
  layout: 'absolute'

win.add view

imageContainer = Ti.UI.createView
  layout: 'vertical'
  width: 320
  height: '68'
  top: 0
  left: 0

image = Ti.UI.createImageView
  image: bookmark.user.profile_image_url
  width: 48
  height: 48
  top: 10
  left: 10

name = Ti.UI.createLabel
  width: 'auto'
  height: 48
  left: 65
  top: 10
  color: "#000"
  font:
    fontSize : 18
    fontWeight: 'bold'

bodyContainer = Ti.UI.createView
  layout: 'vertical'
  width: 300
  height: 'auto'
  top: 78
  left: 10

comment = Ti.UI.createLabel
  color: '#000'
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
  # highlightedColor: '#3B5998'
  top: 0
  left: 0

favicon = Ti.UI.createImageView
  image: bookmark.favicon_url
  width: 16
  height: 16
  top: 2
  left: 0

title = Ti.UI.createLabel
  color: '#3B5998'
  top: 0
  left: 3
  width: 'auto'
  height: 'auto'
  font:
    fontSize: 16

link = Ti.UI.createLabel
  color: '#666'
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
  top: 6
  left: 0

date = Ti.UI.createLabel
  width: 'auto'
  height: 'auto'
  top: 0
  left: 0
  color: '#999'
  font:
    fontSize: 13

count = Ti.UI.createLabel
  width: 'auto'
  height: 'auto'
  top: 0
  left: 0
  color: '#999'
  font:
    fontSize: 14

imageContainer.add image

if bookmark.comment?.length > 0
  bodyContainer.add comment
titleContainer.add favicon
titleContainer.add title
bodyContainer.add titleContainer
bodyContainer.add link
footerContainer.add date
footerContainer.add count
bodyContainer.add footerContainer

name.text    = bookmark.user.name
comment.text = bookmark.comment ? ""
title.text   = bookmark.title
link.text    = bookmark.link
date.text    = bookmark.created_at
count.text   = ", #{bookmark.count}users"

view.add imageContainer
view.add name
view.add bodyContainer

titleContainer.addEventListener 'click', ->
  webView = Ti.UI.createWindow
    url: 'webview.js'
    title: bookmark.title
    backgroundColor: '#fff'
    link: bookmark.link
  Ti.UI.currentTab.open webView