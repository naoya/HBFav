var nameField, nameLabel, nameNoteLabel, passwordField, passwordLabel, passwordNoteLabel, view, win;
require('lib/underscore');
Ti.include('ui.js');
view = Ti.UI.createView({
  layout: 'vertical'
});
nameLabel = Ti.UI.createLabel(_($$.form.label).extend({
  top: 12,
  left: 15,
  text: "はてなID"
}));
nameField = Ti.UI.createTextField(_($$.form.textInput).extend({
  hintText: 'はてなID',
  value: Ti.App.Properties.getString('hatena_id'),
  clearButtonMode: Ti.UI.INPUT_BUTTONMODE_ONFOCUS,
  autocapitalization: Ti.UI.TEXT_AUTOCAPITALIZATION_NONE
}));
nameNoteLabel = Ti.UI.createLabel(_($$.form.notice).extend({
  top: 12,
  text: "プライベート設定のIDは利用できません"
}));
passwordLabel = Ti.UI.createLabel(_($$.form.label).extend({
  top: 12,
  left: 15,
  text: "パスワード"
}));
passwordField = Ti.UI.createTextField(_($$.form.textInput).extend({
  hintText: 'パスワード',
  value: Ti.App.Properties.getString('hatena_password'),
  passwordMask: true,
  autocapitalization: Ti.UI.TEXT_AUTOCAPITALIZATION_NONE
}));
passwordNoteLabel = Ti.UI.createLabel(_($$.form.notice).extend({
  top: 12,
  text: "はてなブックマークへの投稿機能を利用しない場合、パスワードの入力は不要です"
}));
view.add(nameLabel);
view.add(nameField);
view.add(nameNoteLabel);
view.add(passwordLabel);
view.add(passwordField);
view.add(passwordNoteLabel);
win = Ti.UI.currentWindow;
HBFav.UI.setupConfigWindow(win, function(e) {
  Ti.App.Properties.setString('hatena_id', nameField.value);
  Ti.App.Properties.setString('hatena_password', passwordField.value);
  return win.close();
});
win.add(view);