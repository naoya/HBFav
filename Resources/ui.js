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
        return ui.image = cacheFilePath;
      } else {
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
  },
  createMessageWin: function() {
    var ind, label, msgwin, view, win;
    win = Ti.UI.createWindow({
      height: 40,
      width: 250,
      bottom: 70,
      borderRadius: 10,
      touchEnabled: false
    });
    view = Ti.UI.createView({
      height: 40,
      width: 250,
      borderRadius: 10,
      backgroundColor: '#000',
      opacity: 0.7,
      touchEnabled: false
    });
    label = Ti.UI.createLabel({
      text: "",
      color: "#fff",
      width: 250,
      height: 'auto',
      textAlign: 'center',
      font: {
        fontSize: 13
      }
    });
    ind = Ti.UI.createActivityIndicator({
      style: Ti.UI.iPhone.ActivityIndicatorStyle.PLAIN,
      message: "",
      color: '#fff',
      font: {
        fontSize: 13
      }
    });
    win.add(view);
    win.add(ind);
    win.add(label);
    msgwin = {
      win: win,
      view: view,
      indicator: ind,
      label: label,
      open: function() {
        return win.open();
      },
      close: function() {
        ind.hide();
        return setTimeout(function() {
          return win.close({
            opacity: 0,
            duration: 500
          });
        }, 1000);
      }
    };
    return msgwin;
  },
  setupConfigWindow: function(win, callback) {
    var cancelButton, doneButton;
    win.backgroundColor = 'stripped';
    doneButton = Ti.UI.createButton({
      style: Ti.UI.iPhone.SystemButtonStyle.DONE,
      visible: true,
      title: '保存'
    });
    doneButton.addEventListener('click', callback);
    cancelButton = Ti.UI.createButton({
      visible: true,
      title: "キャンセル"
    });
    cancelButton.addEventListener('click', function(e) {
      return win.close();
    });
    win.setRightNavButton(doneButton);
    return win.setLeftNavButton(cancelButton);
  }
};
Ti.include('styles.js');