win = Ti.UI.currentWindow
win.backgroundColor = 'stripped'

view = Ti.UI.createView
  layout: 'vertical'

nameLabel = Ti.UI.createLabel
  width: 'auto'
  height: 'auto'
  top: 12
  left: 15
  text: "はてなID"
  color: "#333"
  shadowColor: "#fff"
  shadowOffset:
    x: 0
    y: 1
  font:
    fontSize: 14
    fontWeight: "bold"

nameField = Ti.UI.createTextField
  color: '#194C7F'
  top: 6
  left: 10
  width: 300
  height: 40
  hintText: 'はてなID'
  clearButtonMode: Ti.UI.INPUT_BUTTONMODE_ONFOCUS
  autocapitalization: Ti.UI.TEXT_AUTOCAPITALIZATION_NONE
  backgroundColor: "#fff"
  borderRadius: 10
  font:
    fontSize: 16
  value: Ti.App.Properties.getString 'hatena_id'
  paddingLeft: 10
  paddingRight: 10

passwordLabel = Ti.UI.createLabel
  width: 'auto'
  height: 'auto'
  top: 12
  left: 15
  text: "パスワード"
  color: "#333"
  shadowColor: "#fff"
  shadowOffset:
    x: 0
    y: 1
  font:
    fontSize: 14
    fontWeight: "bold"

passwordField = Ti.UI.createTextField
  value: Ti.App.Properties.getString 'hatena_password'
  top: 6
  left: 10
  width: 300
  height: 40
  color: '#194C7F'
  passwordMask: true
  hintText: 'パスワード'
  autocapitalization: Ti.UI.TEXT_AUTOCAPITALIZATION_NONE
  backgroundColor: '#fff'
  font:
    fontSize: 16
  paddingLeft: 10
  paddingRight: 10
  borderRadius: 10

doneButton = Ti.UI.createButton
  style: Ti.UI.iPhone.SystemButtonStyle.DONE
  visible: true
  title: '保存'

doneButton.addEventListener 'click', (e) ->
  Ti.App.Properties.setString 'hatena_id', nameField.value
  Ti.App.Properties.setString 'hatena_password', passwordField.value
  win.close()

win.setRightNavButton doneButton

view.add nameLabel
view.add nameField
view.add passwordLabel
view.add passwordField
win.add view

cancelButton = Ti.UI.createButton
  visible: true
  title: "キャンセル"

cancelButton.addEventListener 'click', (e) ->
  win.close()

win.setLeftNavButton cancelButton