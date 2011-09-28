require 'lib/underscore'

user = 'naoya'
url = "http://localhost:3000/#{user}"
lastRow = 0

win = Ti.UI.currentWindow

data = []
tableView = Ti.UI.createTableView
  data: data

win.add tableView

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
    feed = JSON.parse @.responseText
    endReloading feed
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

## Initializing
xhr = Ti.Network.createHTTPClient()
xhr.open 'GET', url
xhr.onload = ->
  feed = JSON.parse @.responseText
  updateTimeline feed
xhr.send()

feedToRow = (feed) ->
  return _(feed.bookmarks).map (bookmark) ->
    row = Ti.UI.createTableViewRow
      height: 'auto'
      layout: 'absolute'

    imageContainer = Ti.UI.createView
      layout: 'vertical'
      width: 320
      height: '68'
      top: 0
      left: 0

    image = Ti.UI.createImageView
      image: bookmark.user.profile_image_url
      width: 48
      height: 48
      top: 10
      left: 10
      borderRadius: 5

    name = Ti.UI.createLabel
      width: 'auto'
      height: 'auto'
      left: 65
      top: 10
      color: "#000"
      font:
        "font-size" : 12
        fontWeight: 'bold'

    bodyContainer = Ti.UI.createView
      layout: 'vertical'
      width: 245
      height: 'auto'
      top: 33
      left: 65
      bottom: 10

    comment = Ti.UI.createLabel
      color: '#000'
      top: 0
      left: 0
      width: 'auto'
      height: 'auto'
      bottom: 6
      font:
        "font-size": 14

    titleContainer = Ti.UI.createView
      layout: 'horizontal'
      width: 245
      height: 'auto'
      top: 0
      left: 0
      # bottom: 10

    favicon = Ti.UI.createImageView
      image: bookmark.favicon_url
      width: 14
      height: 14
      top: 2
      left: 0

    title = Ti.UI.createLabel
      color: '#3B5998'
      top: 0
      left: 3
      width: 'auto'
      height: 'auto'
      font:
        "font-size": 14

    date = Ti.UI.createLabel
      width: 'auto'
      height: 'auto'
      top: 10
      right: 10
      color: '#999'
      font:
        fontSize: 12

    imageContainer.add image

    if bookmark.comment?.length > 0
      bodyContainer.add comment
    titleContainer.add favicon
    titleContainer.add title
    bodyContainer.add titleContainer

    name.text    = bookmark.user.name
    comment.text = bookmark.comment ? ""
    title.text   = bookmark.title
    date.text    = bookmark.created_at

    row.add imageContainer
    row.add name
    row.add bodyContainer
    row.add date

    row.addEventListener 'click', (e) ->
      permalink = Ti.UI.createWindow
        url: 'permalink.js'
        title: bookmark.user.name
        backgroundColor: '#fff'
        bookmark: bookmark
      Ti.UI.currentTab.open permalink
    row

updateTimeline = (feed) ->
  tableView.setData feedToRow feed
  lastRow = feed.bookmarks.length

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
    feed = JSON.parse @.responseText
    endUpdate feed
  xhr.send()

endUpdate = (feed) ->
  updating = false
  tableView.deleteRow lastRow,
    animationStyle: Ti.UI.iPhone.RowAnimationStyle.NONE
  rows = feedToRow feed
  _(rows).each (row) ->
    tableView.appendRow row,
      animationStyle: Ti.UI.iPhone.RowAnimationStyle.NONE
  lastRow += rows.length
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