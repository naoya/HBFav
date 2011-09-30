require 'lib/underscore'
Feed = require('feed').Feed

user = 'naoya'
url = "http://localhost:3000/#{user}"
lastRow = 0

win = Ti.UI.currentWindow

data = []
tableView = Ti.UI.createTableView
  data: data

win.add tableView

updateTimeline = (feed) ->
  tableView.setData feed.toRows()
  lastRow = feed.size()

## Initializing
xhr = Ti.Network.createHTTPClient()
xhr.open 'GET', url
xhr.onload = ->
  data = JSON.parse @.responseText
  updateTimeline new Feed data
xhr.send()

## Pull to Refresh

# function formatDate()
# {
#   var date = new Date();
#   var datestr = date.getMonth()+'/'+date.getDate()+'/'+date.getFullYear();
#   if (date.getHours()>=12)
#   {
#     datestr+=' '+(date.getHours()==12 ? date.getHours() : date.getHours()-12)+':'+date.getMinutes()+' PM';
#   }
#   else
#   {
#     datestr+=' '+date.getHours()+':'+date.getMinutes()+' AM';
#   }
#   return datestr;
# }

border = Ti.UI.createView
  backgroundColor:"#576c89"
  height:2
  bottom:0

tableHeader = Ti.UI.createView
  backgroundColor:"#e2e7ed"
  width:320
  height:60

tableHeader.add border

arrow = Ti.UI.createView
  backgroundImage:"./images/whiteArrow.png"
  width:23
  height:60
  bottom:10
  left:20

statusLabel = Ti.UI.createLabel
  text: "画面を引き下げて…"
  left:55
  width:200
  bottom:30
  height:"auto"
  color:"#576c89"
  textAlign:"center"
  font:
    fontSize:12
    fontWeight:"bold"
  shadowColor:"#999"
  shadowOffset:
    x:0
    y:1

lastUpdatedLabel = Ti.UI.createLabel
  # text:"Last Updated: "+formatDate(),
  text: "最後の更新: "
  left:55
  width:200
  bottom:15
  height:"auto"
  color:"#576c89"
  textAlign:"center"
  font:
    fontSize:11
  shadowColor:"#999",
  shadowOffset:
    x:0
    y:1

actInd = Titanium.UI.createActivityIndicator
  left:20
  bottom:13
  width:30
  height:30

tableHeader.add arrow
tableHeader.add statusLabel
tableHeader.add lastUpdatedLabel
tableHeader.add actInd

tableView.headerPullView = tableHeader

pulling   = false
reloading = false

beginReloading = ->
  xhr = Ti.Network.createHTTPClient()
  xhr.open 'GET', url
  xhr.onload = ->
    data = JSON.parse @.responseText
    endReloading new Feed data
  xhr.send()

endReloading = (feed) ->
  updateTimeline(feed)
  tableView.setContentInsets({top:0},{animated:true})
  reloading = false
  ## lastUpdatedLabel.text = "Last Updated: "+formatDate();
  lastUpdatedLabel.text = "最後の更新: "
  statusLabel.text = "画面を引き下げて…";
  actInd.hide()
  arrow.show()

tableView.addEventListener 'scroll', (e) ->
  offset = e.contentOffset.y;
  if offset <= -65.0 and not pulling
    t = Ti.UI.create2DMatrix()
    t = t.rotate -180
    pulling = true
    arrow.animate transform:t, duration:180
    statusLabel.text = "指をはなして更新…"
  else if pulling and offset > -65.0 and offset < 0
    pulling = false;
    t = Ti.UI.create2DMatrix()
    arrow.animate transform:t,duration:180
    statusLabel.text = "画面を引き下げて…"

tableView.addEventListener 'scrollEnd', (e) ->
  if pulling and not reloading and e.contentOffset.y <= -65.0
    reloading = true
    pulling = false
    arrow.hide()
    actInd.show()
    statusLabel.text = "読み込み中…"
    tableView.setContentInsets({top:60},{animated:true})
    arrow.transform=Ti.UI.create2DMatrix();
    beginReloading();

## Paging
navActInd = Ti.UI.createActivityIndicator()
win.setRightNavButton navActInd

updating = false
loadingRow = Ti.UI.createTableViewRow
  title: "更新中…"

beginUpdate = ->
  updating = true
  navActInd.show()
  tableView.appendRow loadingRow

  xhr = Ti.Network.createHTTPClient()
  xhr.open 'GET', url + "?of=#{lastRow}"
  xhr.onload = ->
    data = JSON.parse @.responseText
    endUpdate new Feed data
  xhr.send()

endUpdate = (feed) ->
  updating = false
  tableView.deleteRow lastRow,
    animationStyle: Ti.UI.iPhone.RowAnimationStyle.NONE
  rows = feed.toRows()
  _(rows).each (row) ->
    tableView.appendRow row,
      animationStyle: Ti.UI.iPhone.RowAnimationStyle.NONE
  lastRow += feed.size()
  # tableView.scrollToIndex lastRow - rows.length - 1,
  #  animated:true
  #  position:Ti.UI.iPhone.TableViewScrollPosition.BOTTOM
  navActInd.hide()

lastDistance = 0
tableView.addEventListener 'scroll', (e) ->
  offset   = e.contentOffset.y
  height   = e.size.height
  total    = offset + height
  theEnd   = e.contentSize.height
  distance = theEnd - total
  if distance < lastDistance
    nearEnd = theEnd * .75
    if not updating and (total >= nearEnd)
      beginUpdate()
  lastDistance = distance
