win = Ti.UI.currentWindow

doneButton = Ti.UI.createButton
  title: '完了'
  visible: true

doneButton.addEventListener 'click', (e) ->
  win.close()

win.setRightNavButton doneButton