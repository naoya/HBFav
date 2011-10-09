require 'lib/underscore'

win = Ti.UI.currentWindow
bookmark = win.bookmark
link = encodeURI bookmark.link

## Node側でやる?
url = "http://b.hatena.ne.jp/entry/jsonlite/?url=#{link}"

table = Ti.UI.createTableView
  data: []
win.add table

xhr = Ti.Network.createHTTPClient()
xhr.timeout = 100000
xhr.open 'GET', url

Ti.API.debug link
Ti.API.debug url

xhr.onerror = (e)->
  alert e.error

xhr.onload = ->
  data = JSON.parse @.responseText
  Ti.API.debug data
  rows = _(data.bookmarks).map (b) ->
    row = Ti.UI.createTableViewRow
      height: 'auto'
      layout: 'absolute'

    row.addEventListener 'click', (e) ->
      permalink = Ti.UI.createWindow
        url: 'permalink.js'
        title: b.user
        backgroundColor: '#fff'
        bookmark:
          user:
            name: b.user
            profile_image_url: "http://www.st-hatena.com/users/" + b.user.substr(0, 2) + "/#{b.user}/profile.gif"
          favicon_url: "http://favicon.st-hatena.com/?url=#{data.entry_url}"
          title: data.title
          count: data.count
          link: data.entry_url
          created_at: b.timestamp
          comment: b.comment
      Ti.UI.currentTab.open permalink

    imageContainer = Ti.UI.createView
      layout: 'vertical'
      width: 320
      height: '68'
      top: 0
      left: 0

    ## FIXME: サーバサイドとコード被ってる
    image = Ti.UI.createImageView
      image: "http://www.st-hatena.com/users/" + b.user.substr(0, 2) + "/#{b.user}/profile.gif"
      width: 48
      height: 48
      top: 10
      left: 10
      borderRadius: 5
    imageContainer.add image

    bodyContainer = Ti.UI.createView
      layout: 'vertical'
      width: 245
      height: 'auto'
      left: 65
      top: 0

    name = Ti.UI.createLabel
      width: 'auto'
      height: 'auto'
      left: 0
      top: 10
      bottom: 5
      color: '#000'
      font:
        "font-size" : 12
        fontWeight: 'bold'

    comment = Ti.UI.createLabel
      color: '#000'
      top: 0
      left: 0
      width: 'auto'
      height: 'auto'
      bottom: 10
      font:
        "font-size": 14

    date = Ti.UI.createLabel
      width: 'auto'
      height: 'auto'
      top: 10
      right: 10
      color: '#999'
      font:
        fontSize: 12

    name.text    = b.user
    comment.text = b.comment
    date.text    = b.timestamp ? ""

    bodyContainer.add name
    bodyContainer.add comment

    row.add imageContainer
    row.add bodyContainer
    row.add date
    row

  table.setData rows

xhr.send()