Ti.include('lib/sha1.js');
if (typeof HBFav === "undefined" || HBFav === null) {
  HBFav = {};
}
HBFav.UI = {
  createImageView: function(options) {
    var ui;
    ui = Ti.UI.createImageView(options);
    ui.imageWithCache = function(url) {
      var cacheFile, cacheFilePath, timestamp;
      url = url.replace(/\?[0-9]+$/, '');
      cacheFilePath = Ti.Filesystem.tempDirectory + hex_sha1(url);
      cacheFile = Ti.Filesystem.getFile(cacheFilePath);
      if (cacheFile.exists()) {
        timestamp = cacheFile.modificationTimestamp();
        Ti.API.debug("cache hit: " + cacheFilePath + " [" + timestamp + "]");
        return ui.image = cacheFilePath;
      } else {
        Ti.API.debug("cache miss: " + url);
        ui.addEventListener('load', function() {
          cacheFile = Ti.Filesystem.getFile(cacheFilePath);
          if (!cacheFile.exists()) {
            return cacheFile.write(ui.toBlob());
          }
        });
        return ui.image = url;
      }
    };
    return ui;
  }
};