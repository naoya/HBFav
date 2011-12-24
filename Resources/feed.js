var Feed, _;
_ = require('/lib/underscore');
Ti.include('ui.js');
Ti.include('util.js');
Feed = (function() {
  function Feed(f) {
    this.f = f;
  }
  Feed.prototype.size = function() {
    return this.f.bookmarks.length;
  };
  Feed.prototype.toRows = function() {
    var _ref;
    return (_ref = this.f.bookmarks) != null ? _ref.map(function(bookmark) {
      var bodyContainer, comment, date, favicon, image, imageContainer, name, row, title, titleContainer, _ref2;
      row = Ti.UI.createTableViewRow({
        height: 'auto',
        layout: 'absolute',
        bookmark: bookmark
      });
      imageContainer = Ti.UI.createView($$.timeline.profileImageContainer);
      image = HBFav.UI.createImageView($$.timeline.profileImage);
      imageContainer.add(image);
      image.imageWithCache($$$.profileImageUrlLarge(bookmark.user.name));
      bodyContainer = Ti.UI.createView($$.timeline.bodyContainer);
      name = Ti.UI.createLabel(_($$.timeline.nameLabel).extend({
        text: bookmark.user.name
      }));
      bodyContainer.add(name);
      if (bookmark.comment.length > 0) {
        comment = Ti.UI.createLabel(_($$.timeline.commentLabel).extend({
          text: (_ref2 = bookmark.comment) != null ? _ref2 : "",
          bottom: 6
        }));
        bodyContainer.add(comment);
      }
      titleContainer = Ti.UI.createView($$.timeline.titleContainer);
      favicon = HBFav.UI.createImageView($$.timeline.favicon);
      favicon.imageWithCache(bookmark.favicon_url);
      title = Ti.UI.createLabel(_($$.timeline.titleLabel).extend({
        text: bookmark.title
      }));
      titleContainer.add(favicon);
      titleContainer.add(title);
      bodyContainer.add(titleContainer);
      date = Ti.UI.createLabel(_($$.timeline.dateLabel).extend({
        text: bookmark.created_at
      }));
      row.add(imageContainer);
      row.add(bodyContainer);
      row.add(date);
      return row;
    }) : void 0;
  };
  return Feed;
})();