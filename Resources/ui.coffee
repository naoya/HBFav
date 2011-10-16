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
        # Ti.API.debug "cache hit: #{cacheFilePath} [#{timestamp}]"
        ui.image = cacheFilePath
      else
        # Ti.API.debug "cache miss: #{url}"
        ui.addEventListener 'load', () ->
          cacheFile = Ti.Filesystem.getFile cacheFilePath
          if not cacheFile.exists()
            cacheFile.write ui.toBlob()
        ui.image = url
    return ui

  createMessageWin: () ->
    win = Ti.UI.createWindow
      height: 40
      width: 250
      bottom: 70
      borderRadius: 10
      touchEnabled: false

    view = Ti.UI.createView
      height: 40
      width: 250
      borderRadius: 10
      backgroundColor: '#000'
      opacity: 0.7
      touchEnabled: false

    label = Ti.UI.createLabel
      text: ""
      color: "#fff"
      width: 250
      height: 'auto'
      textAlign: 'center'
      font:
        fontSize: 13

    ind =  Ti.UI.createActivityIndicator
      style: Ti.UI.iPhone.ActivityIndicatorStyle.PLAIN
      message: ""
      color: '#fff'
      font:
        fontSize: 13

    win.add view
    win.add ind
    win.add label

    msgwin =
      win: win
      view: view
      indicator: ind
      label: label
      open: ->
        win.open()
      close: ->
        ind.hide()
        setTimeout ->
          win.close
            opacity: 0
            duration: 500
        , 1000
    return msgwin