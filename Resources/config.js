(function() {
  var doneButton, win;
  win = Ti.UI.currentWindow;
  doneButton = Ti.UI.createButton({
    title: '完了',
    visible: true
  });
  doneButton.addEventListener('click', function(e) {
    return win.close();
  });
  win.setRightNavButton(doneButton);
}).call(this);
