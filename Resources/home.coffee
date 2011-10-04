require 'lib/underscore'
Feed = require('feed').Feed

user = 'naoya'
url = "http://localhost:3000/#{user}"

## FIXME: global variable
lastRow = 0

win = Ti.UI.currentWindow

data = []
tableView = Ti.UI.createTableView
  data: data

win.add tableView

## Pull to Refresh 用
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

## Paging用
navActInd = Ti.UI.createActivityIndicator()
win.setRightNavButton navActInd
loadingRow = Ti.UI.createTableViewRow
  title: "更新中…"

## State pattern
state = null

transitState = (nextState) ->
  Ti.API.debug " -> "  + nextState.toString()
  state = nextState
  do state.execute

class AbstractState
  toString : () ->  'AbstractState'
  constructor: () ->
  getFeed : (url) ->
    cb = @.onload
    xhr = Ti.Network.createHTTPClient()
    xhr.open 'GET', url
    xhr.onload = ->
      data = JSON.parse @.responseText
      cb data
    xhr.send()
  ## events (do nothing)
  onload :    ()  ->
  scroll :    (e) ->
  scrollEnd : (e) ->
  execute :   ()  ->

class NormalState extends AbstractState
  toString : () -> 'NormalState'
  constructor: () ->
    # @pulling = false
    @lastDistance = 0
  scroll : (e) ->
    offset = e.contentOffset.y;
    if offset <= -65.0
      ## pull to refresh
      t = Ti.UI.create2DMatrix()
      t = t.rotate -180
      arrow.animate transform:t, duration:180
      statusLabel.text = "指をはなして更新…"
      transitState new PullingState
    else
      ## paging
      height   = e.size.height
      total    = offset + height
      theEnd   = e.contentSize.height
      distance = theEnd - total
      if distance < @lastDistance
        nearEnd = theEnd * .75
        if total >= nearEnd
          transitState new PagingStartState
      @lastDistance = distance

class PullingState extends AbstractState
  toString: () -> "PullingState"
  scroll: (e) ->
    offset = e.contentOffset.y;
    if offset > -65.0 and offset < 0
      t = Ti.UI.create2DMatrix()
      arrow.animate transform:t,duration:180
      statusLabel.text = "画面を引き下げて…"
      transitState new NormalState
  scrollEnd: (e) ->
    if e.contentOffset.y <= -65.0
      arrow.hide()
      actInd.show()
      statusLabel.text = "読み込み中…"
      tableView.setContentInsets({top:60},{animated:true})
      arrow.transform = Ti.UI.create2DMatrix();
      transitState new ReloadStartState

class ReloadStartState extends AbstractState
  toString : () ->  "ReloadStartState"
  execute: () ->
    @.getFeed url
  onload : (data) ->
    transitState new ReloadEndState data

class ReloadEndState extends AbstractState
  toString : () -> "ReloadEndState"
  constructor: (@data) ->
  execute : () ->
    feed = new Feed @data
    tableView.setData feed.toRows()
    lastRow = feed.size()
    tableView.setContentInsets({top:0},{animated:true})
    lastUpdatedLabel.text = "最後の更新: "
    statusLabel.text = "画面を引き下げて…";
    actInd.hide()
    arrow.show()
    transitState new NormalState

class PagingStartState extends AbstractState
  toString: () -> "PagingStartState"
  execute: () ->
    navActInd.show()
    tableView.appendRow loadingRow
    @.getFeed url + "?of=#{lastRow}"
  onload: (data) ->
    transitState new PagingEndState data

class PagingEndState extends AbstractState
  toString: () -> "PagingEndState"
  constructor: (@data) ->
  execute: () ->
    feed = new Feed @data
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
    transitState new NormalState

class InitStartState extends AbstractState
  toString : () -> "InitStartState"
  execute: () ->
    @.getFeed url
  onload : (data) ->
    transitState new InitEndState data

class InitEndState extends AbstractState
  toString : () -> "InitEndState"
  constructor: (@data) ->
  execute : () ->
    feed = new Feed @data
    tableView.setData feed.toRows()
    lastRow = feed.size()
    transitState new NormalState

transitState new InitStartState

tableView.addEventListener 'scroll', (e) ->
  state.scroll e

tableView.addEventListener 'scrollEnd', (e) ->
  state.scrollEnd e