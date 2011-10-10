var doneButton, nameField, win;
win = Ti.UI.currentWindow;
win.backgroundColor = 'stripped';
nameField = Ti.UI.createTextField({
  color: '#194C7F',
  top: 25,
  left: 10,
  height: 40,
  width: 300,
  hintText: 'はてなID',
  borderStyle: Ti.UI.INPUT_BORDERSTYLE_LINE,
  clearButtonMode: Ti.UI.INPUT_BUTTONMODE_ONFOCUS,
  autocapitalization: Ti.UI.TEXT_AUTOCAPITALIZATION_NONE,
  backgroundColor: "#fff",
  borderColor: "#ababab",
  borderRadius: 10,
  font: {
    fontSize: 16
  },
  value: Ti.App.Properties.getString('hatena_id'),
  paddingLeft: 10,
  paddingRight: 10
});
doneButton = Ti.UI.createButton({
  style: Ti.UI.iPhone.SystemButtonStyle.DONE,
  visible: true,
  title: '保存'
});
doneButton.addEventListener('click', function(e) {
  Ti.App.Properties.setString('hatena_id', nameField.value);
  return win.close();
});
win.setRightNavButton(doneButton);
win.add(nameField);