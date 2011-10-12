require 'lib/underscore'

class Feed
  constructor: (@f) ->
    Ti.API.debug 'Feed initialize'

  size: ->
    @f.bookmarks.length

  toRows: (win) ->
    return _(@f.bookmarks).map (bookmark) ->
      row = Ti.UI.createTableViewRow
        height: 'auto'
        layout: 'absolute'

      row.addEventListener 'click', (e) ->
        permalink = Ti.UI.createWindow
          url: 'permalink.js'
          title: "ブックマーク"
          bookmark: bookmark
        Ti.UI.currentTab.open permalink

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
        borderRadius: 5

      bodyContainer = Ti.UI.createView
        layout: 'vertical'
        width: 245
        height: 'auto'
        left: 65
        # bottom: 10
        top: 0

      name = Ti.UI.createLabel
        width: 'auto'
        height: 'auto'
        left: 0
        top: 10
        bottom: 5
        color: "#000"
        font:
          fontSize : 15
          fontWeight: 'bold'

      comment = Ti.UI.createLabel
        color: '#000'
        top: 0
        left: 0
        width: 'auto'
        height: 'auto'
        bottom: 6
        font:
          fontSize: 15

      titleContainer = Ti.UI.createView
        layout: 'horizontal'
        width: 245
        height: 'auto'
        top: 0
        left: 0
        # bottom: 2
        bottom: 10

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
          fontSize: 15

      date = Ti.UI.createLabel
        width: 'auto'
        height: 'auto'
        top: 10
        right: 10
        color: '#999'
        font:
          fontSize: 14

      # count = Ti.UI.createLabel
      #   width: 'auto'
      #   height: 'auto'
      #   top: 0
      #   left: 16
      #   bottom: 10
      #   color: '#999'
      #   font:
      #     fontSize: 12

      imageContainer.add image
      bodyContainer.add name

      if bookmark.comment?.length > 0
        bodyContainer.add comment
      titleContainer.add favicon
      titleContainer.add title
      bodyContainer.add titleContainer
      # bodyContainer.add count

      name.text    = bookmark.user.name
      comment.text = bookmark.comment ? ""
      title.text   = bookmark.title
      date.text    = bookmark.created_at
#      count.text   = if bookmark.count > 1 then "#{bookmark.count} users" else "#{bookmark.count} user"

      row.add imageContainer
      # row.add name
      row.add bodyContainer
      row.add date
      row

# exports.Feed = Feed