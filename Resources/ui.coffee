Ti.include 'lib/sha1.js'

HBFav ?= {}
HBFav.UI =
  createImageView: (options) ->
    ui = Ti.UI.createImageView options
    ui.imageWithCache = (url) ->
      url = url.replace /\?[0-9]+$/, ''

      cacheFilePath = Ti.Filesystem.tempDirectory + hex_sha1(url)
      cacheFile = Ti.Filesystem.getFile cacheFilePath

      if cacheFile.exists()
        timestamp = cacheFile.modificationTimestamp()
        Ti.API.debug "cache hit: #{cacheFilePath} [#{timestamp}]"
        ui.image = cacheFilePath
      else
        Ti.API.debug "cache miss: #{url}"
        ui.addEventListener 'load', () ->
          cacheFile = Ti.Filesystem.getFile cacheFilePath
          if not cacheFile.exists()
            cacheFile.write ui.toBlob()
        ui.image = url
    return ui
