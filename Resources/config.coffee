require 'lib/underscore'
Ti.include 'ui.js'

view = Ti.UI.createView
  layout: 'vertical'

nameLabel = Ti.UI.createLabel _($$.form.label).extend
  top: 12
  left: 15
  text: "はてなID"

nameField = Ti.UI.createTextField _($$.form.textInput).extend
  hintText: 'はてなID'
  value: Ti.App.Properties.getString 'hatena_id'
  clearButtonMode: Ti.UI.INPUT_BUTTONMODE_ONFOCUS
  autocapitalization: Ti.UI.TEXT_AUTOCAPITALIZATION_NONE

passwordLabel = Ti.UI.createLabel _($$.form.label).extend
  top: 12
  left: 15
  text: "パスワード"

passwordField = Ti.UI.createTextField _($$.form.textInput).extend
  hintText: 'パスワード'
  value: Ti.App.Properties.getString 'hatena_password'
  passwordMask: true
  autocapitalization: Ti.UI.TEXT_AUTOCAPITALIZATION_NONE

noteLabel = Ti.UI.createLabel _($$.form.notice).extend
  top: 12
  text: "はてなブックマークへの投稿機能を利用しない場合はパスワードの入力は不要です"

view.add nameLabel
view.add nameField
view.add passwordLabel
view.add passwordField
view.add noteLabel

win = Ti.UI.currentWindow

HBFav.UI.setupConfigWindow win, (e) ->
  Ti.App.Properties.setString 'hatena_id', nameField.value
  Ti.App.Properties.setString 'hatena_password', passwordField.value

win.add view
