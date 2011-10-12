Ti.include 'feedview.js'
Ti.include 'ui.js'

win = Ti.UI.currentWindow
win.layout = 'vertical'
# win.backgroundColor = "stripped"
bookmark = win.bookmark

view = Ti.UI.createView
  top: 0
  left: 0
  width: 'auto'
  height: 'auto'
  layout: 'absolute'
  backgroundColor: "#fff"
  # showHorizontalScrollIndicator:true

win.add view

imageContainer = Ti.UI.createView
  layout: 'vertical'
  width: 320
  height: '68'
  top: 0
  left: 0
  # backgroundColor: "#fff"
  # backgroundColor: "#B8C4D2"
  backgroundColor: "stripped"

image = HBFav.UI.createImageView
  width: 48
  height: 48
  top: 10
  left: 10
  borderRadius: 5
image.imageWithCache bookmark.user.profile_image_url

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

border = Ti.UI.createView
  backgroundColor: "#ababab"
  top: 68
  height: 1

bodyContainer = Ti.UI.createView
  layout: 'vertical'
  width: 300
  height: 'auto'
  # backgroundColor: "#000"
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

favicon = HBFav.UI.createImageView
  width: 16
  height: 16
  top: 2
  left: 0
favicon.imageWithCache bookmark.favicon_url

title = Ti.UI.createLabel
  color: '#3B5998'
  top: 0
  left: 3
  width: 'auto'
  height: 'auto'
  font:
    fontSize: 18

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
  top: 3
  left: 0

date = Ti.UI.createLabel
  width: 'auto'
  height: 'auto'
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
# footerContainer.add count
bodyContainer.add footerContainer

name.text    = bookmark.user.name
comment.text = bookmark.comment ? ""
title.text   = bookmark.title
link.text    = bookmark.link
date.text    = bookmark.created_at
# count.text   = ", #{bookmark.count}users"

view.add imageContainer
view.add border
view.add name
view.add bodyContainer

## xx users navigation
button = Ti.UI.createButton
  title: if bookmark.count > 1 then "#{bookmark.count} users" else "#{bookmark.count} user"
  height: 40
  width: 300
  top: 10
  textAlign: "left"

button.addEventListener 'click', (e) ->
  bookmarksWin = Ti.UI.createWindow
    url: 'bookmarks.js'
    title: "#{bookmark.count} users"
    backgroundColor: "#fff"
    bookmark: bookmark
  Ti.UI.currentTab.open bookmarksWin

win.add button

imageContainer.addEventListener 'click', ->
  profile = Ti.UI.createWindow
    url: 'profile.js'
    title: bookmark.user.name
    user: bookmark.user
  Ti.UI.currentTab.open profile

bodyContainer.addEventListener 'click', ->
  webView = Ti.UI.createWindow
    url: 'webview.js'
    title: bookmark.title
    backgroundColor: '#fff'
    link: bookmark.link
  Ti.UI.currentTab.open webView