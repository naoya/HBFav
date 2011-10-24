require 'lib/underscore'

Ti.include 'ui.js'
Ti.include 'util.js'

win = Ti.UI.currentWindow
bookmark = win.bookmark
link = encodeURI bookmark.link

## FIXME: Node側でやる?
url = "http://b.hatena.ne.jp/entry/jsonlite/?url=#{link}"

## Create Header
header = Ti.UI.createView
  top: 0
  left: 0
  width: 320
  height: 68
  layout: 'vertical'
  backgroundColor: "stripped"

entryContainer = Ti.UI.createView
  layout: 'vertical'
  width: 310
  height: 'auto'
  top: 5
  left: 5
  bottom: 5

titleContainer = Ti.UI.createView
  layout: 'horizontal'
  width: 300
  height: 68
  top: 0
  left: 0

favicon = HBFav.UI.createImageView
  width: 14
  height: 14
  top: 2
  left: 0
favicon.imageWithCache bookmark.favicon_url

title = Ti.UI.createLabel
  color: '#000'
  top: 0
  left: 4
  width: 'auto'
  height: 'auto'
  font:
    fontSize: 13
    fontWeight: "bold"
  backgroundColor: 'transparent'

title.text = bookmark.title
titleContainer.add favicon
titleContainer.add title
entryContainer.add titleContainer
header.add entryContainer

header.addEventListener 'click', ->
  webView = Ti.UI.createWindow
    url: 'webview.js'
    title: bookmark.title
    backgroundColor: '#fff'
    bookmark: bookmark
  Ti.UI.currentTab.open webView

border = Ti.UI.createView
  backgroundColor: "#ababab"
  top: 68
  height: 1

loadingRow = Ti.UI.createTableViewRow()
ind = Ti.UI.createActivityIndicator
  top: 10
  bottom: 10
  style: Ti.UI.iPhone.ActivityIndicatorStyle.DARK
ind.show()
loadingRow.add ind

table = Ti.UI.createTableView
  top: 69
  data: [ loadingRow ]

table.addEventListener 'click', (e) ->
  row = e.rowData
  if row.bookmark
    Ti.UI.currentTab.open Ti.UI.createWindow
      url: 'permalink.js'
      title: 'ブックマーク'
      bookmark: row.bookmark

win.add header
win.add border
win.add table

bookmarks2rows = (data, start, end) ->
  bookmarks = data.bookmarks.slice start, end
  rows = _(bookmarks).map (b) ->
    row = Ti.UI.createTableViewRow
      height: 'auto'
      layout: 'absolute'
      bookmark:
        user:
          name: b.user
          profile_image_url: $$$.profileImageUrl b.user
        favicon_url: "http://favicon.st-hatena.com/?url=#{data.url}"
        title: data.title
        count: data.count
        link: data.url
        created_at: b.timestamp
        comment: b.comment

    # row.addEventListener 'click', (e) ->
    #   permalink = Ti.UI.createWindow
    #     url: 'permalink.js'
    #     title: b.user
    #     backgroundColor: '#fff'
    #     bookmark:
    #       user:
    #         name: b.user
    #         profile_image_url: $$$.profileImageUrl b.user
    #       favicon_url: "http://favicon.st-hatena.com/?url=#{data.url}"
    #       title: data.title
    #       count: data.count
    #       link: data.url
    #       created_at: b.timestamp
    #       comment: b.comment
    #   Ti.UI.currentTab.open permalink

    imageContainer = Ti.UI.createView $$.timeline.profileImageContainer

    image = HBFav.UI.createImageView $$.timeline.profileImage
    image.imageWithCache $$$.profileImageUrl b.user
    imageContainer.add image

    bodyContainer = Ti.UI.createView $$.timeline.bodyContainer

    name = Ti.UI.createLabel _($$.timeline.nameLabel).extend
      text: b.user

    date = Ti.UI.createLabel _($$.timeline.dateLabel).extend
      text: b.timestamp?.substr(0, 10)

    bodyContainer.add name

    if b.comment.length > 0
      comment = Ti.UI.createLabel _($$.timeline.commentLabel).extend
        text: b.comment
      bodyContainer.add comment

    row.add imageContainer
    row.add bodyContainer
    row.add date
    row
  return rows

## Retrieving bookmarks
xhr = Ti.Network.createHTTPClient()
xhr.timeout = 100000
xhr.open 'GET', url

Ti.API.debug link
Ti.API.debug url

xhr.onerror = (e)->
  alert e.error

xhr.onload = ->
  data = JSON.parse @.responseText

  setData = (offset, limit) ->
    rows = bookmarks2rows data, offset, offset + limit
    section = Ti.UI.createTableViewSection()
    _(rows).each (row) ->
      section.add row

    if rows.length == limit
      more = Ti.UI.createTableViewRow()
      label = Ti.UI.createLabel
        text: "もっと見る"
        color: "#194C7F"
        textAlign: "center"
        font:
          fontSize: 16
          fontWeight: "bold"
      more.add label
      more.addEventListener 'click', (e) ->
        loadingInd = Ti.UI.createActivityIndicator
          top: 10
          bottom: 10
          style: Ti.UI.iPhone.ActivityIndicatorStyle.DARK
        loadingInd.show()

        more.remove label
        more.add loadingInd

        offset += limit
        setData(offset, limit)
      section.add more

    if offset is 0
      table.deleteRow offset,
        animationStyle: Ti.UI.iPhone.RowAnimationStyle.NONE
    current = table.data
    current.push section
    table.setData current
    if offset isnt 0
      table.deleteRow offset,
        animationStyle: Ti.UI.iPhone.RowAnimationStyle.NONE
  setData(0, 50)

  xhr.onload = null
  xhr.onerror = null
  xhr = null

xhr.send()