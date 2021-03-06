_ = require '/lib/underscore'

Ti.include 'ui.js'
Ti.include 'util.js'

class Feed
  constructor: (@f) ->
  size: ->
    @f.bookmarks.length
  toRows: ->
    return @f.bookmarks?.map (bookmark) ->
      row = Ti.UI.createTableViewRow
        width: Ti.UI.FILL
        height: Ti.UI.SIZE
        layout: 'absolute'
        bookmark: bookmark

      imageContainer = Ti.UI.createView $$.timeline.profileImageContainer
      image = HBFav.UI.createImageView $$.timeline.profileImage
      imageContainer.add image
      image.imageWithCache $$$.profileImageUrlLarge bookmark.user.name
      bodyContainer = Ti.UI.createView $$.timeline.bodyContainer

      name = Ti.UI.createLabel _($$.timeline.nameLabel).extend
        text: bookmark.user.name
      bodyContainer.add name

      if bookmark.comment.length > 0
        comment = Ti.UI.createLabel _($$.timeline.commentLabel).extend
          text: bookmark.comment ? ""
          bottom: 6
        bodyContainer.add comment

      titleContainer = Ti.UI.createView $$.timeline.titleContainer
      favicon = HBFav.UI.createImageView $$.timeline.favicon
      favicon.imageWithCache bookmark.favicon_url

      title = Ti.UI.createLabel _($$.timeline.titleLabel).extend
        text: bookmark.title

      titleContainer.add favicon
      titleContainer.add title
      bodyContainer.add titleContainer

      date = Ti.UI.createLabel _($$.timeline.dateLabel).extend
        text: bookmark.created_at

      row.add imageContainer
      row.add bodyContainer
      row.add date

      row
