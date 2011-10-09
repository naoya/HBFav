require 'lib/underscore'
# Feed = require('feed').Feed
Ti.include 'feed.js'

class AbstractState
  toString : () ->  'AbstractState'
  constructor: (@feedView) ->
  getFeed : (url) ->
    Ti.API.debug 'getFeed'

    self = @
    onload = @.onload
    onerror = @.onerror

    xhr = Ti.Network.createHTTPClient()
    xhr.timeout = 100000
    xhr.open 'GET', url
    xhr.onload = ->
      Ti.API.debug 'onload'
      Ti.API.debug @.responseText
      data = JSON.parse @.responseText
      Ti.API.debug 'json parsed'
      onload.apply(self, [ data ])
    xhr.onerror = (err) ->
      onerror.apply(self, [ err ])
    xhr.send()

  ## events
  onload :  (data)  ->
  scroll :    (e) ->
  scrollEnd : (e) ->
  execute :   ()  ->
  onerror : (err) -> alert err.error

class NormalState extends AbstractState
  toString : () -> 'NormalState'
  constructor: (@feedView) ->
    @lastDistance = 0
  scroll : (e) ->
    offset = e.contentOffset.y;
    if offset <= -65.0
      ## feedView.header.retain()
      t = Ti.UI.create2DMatrix()
      t = t.rotate -180
      @feedView.header.arrow.animate transform:t, duration:180
      @feedView.header.statusLabel.text = "指をはなして更新…"
      @feedView.transitState new PullingState @feedView
    else
      ## paging
      height   = e.size.height
      total    = offset + height
      theEnd   = e.contentSize.height
      distance = theEnd - total
      if distance < @lastDistance
        nearEnd = theEnd * .75
        if total >= nearEnd
          @feedView.transitState new PagingStartState @feedView
      @lastDistance = distance

class PullingState extends AbstractState
  toString: () -> "PullingState"
  scroll: (e) ->
    offset = e.contentOffset.y;
    if offset > -65.0 and offset < 0
      ## feedView.header.cancel()
      t = Ti.UI.create2DMatrix()
      @feedView.header.arrow.animate transform:t,duration:180
      @feedView.header.statusLabel.text =  "画面を引き下げて…"
      @feedView.transitState new NormalState @feedView
  scrollEnd: (e) ->
    if e.contentOffset.y <= -65.0
      ## feedView.header.reloading()
      @feedView.header.arrow.hide()
      @feedView.header.indicator.show()
      @feedView.header.statusLabel.text = "読み込み中…"
      @feedView.table.setContentInsets({top:60},{animated:true})
      @feedView.header.arrow.transform = Ti.UI.create2DMatrix();
      @feedView.transitState new ReloadStartState @feedView

class ReloadStartState extends AbstractState
  toString : () ->  "ReloadStartState"
  execute: () ->
    @.getFeed @feedView.url
  onload : (data) ->
    @feedView.transitState new ReloadEndState @feedView, data

class ReloadEndState extends AbstractState
  toString : () -> "ReloadEndState"
  constructor: (@feedView, @data) ->
  execute : () ->
    feed = new Feed @data
    @feedView.setFeed feed

    ## feedview.header.hide()
    @feedView.table.setContentInsets({top:0},{animated:true})
    @feedView.header.lastUpdatedLabel.text = "最後の更新: "
    @feedView.header.statusLabel.text = "画面を引き下げて…";
    @feedView.header.indicator.hide()
    @feedView.header.arrow.show()
    @feedView.transitState new NormalState @feedView

class PagingStartState extends AbstractState
  toString: () -> "PagingStartState"
  execute: () ->
    @feedView.pager.show()
    @.getFeed @feedView.url + "?of=#{@feedView.lastRow}"
  onload: (data) ->
    @feedView.transitState new PagingEndState @feedView, data

class PagingEndState extends AbstractState
  toString: () -> "PagingEndState"
  constructor: (@feedView, @data) ->
  execute: () ->
    feed = new Feed @data
    @feedView.pager.hide()
    @feedView.appendFeed feed
    ## TODO
    # tableView.scrollToIndex lastRow - rows.length - 1,
    #  animated:true
    #  position:Ti.UI.iPhone.TableViewScrollPosition.BOTTOM
    @feedView.transitState new NormalState @feedView

class InitStartState extends AbstractState
  toString : () -> "InitStartState"
  constructor: (@feedView) ->
    Ti.API.debug 'constructor'
  execute: () ->
    Ti.API.debug 'start execute'
    @.getFeed @feedView.url
    Ti.API.debug 'end execute'
  onload : (data) ->
    Ti.API.debug 'InitStartState::onload'
    @feedView.transitState new InitEndState @feedView, data

class InitEndState extends AbstractState
  toString : () -> "InitEndState"
  constructor: (@feedView, @data) ->
  execute : () ->
    feed = new Feed @data
    @feedView.setFeed feed
    Ti.API.debug 'setFeed done.'
    @feedView.transitState new NormalState @feedView

class FeedView
  state: null
  transitState: (nextState) ->
    Ti.API.debug " -> "  + nextState.toString()
    @state = nextState
    do @state.execute

  initialize: () ->
    @.transitState new InitStartState @

  constructor: (win: @win, url: @url) ->
    Ti.API.debug 'new FeedView'
    table = Ti.UI.createTableView
      data: []

    table.addEventListener 'scroll', (e) =>
      @state.scroll e
    table.addEventListener 'scrollEnd', (e) =>
      @state.scrollEnd e

    @win.add table
    Ti.API.debug 'Added table'

    ## Pull to Refresh 用
    border = Ti.UI.createView
      backgroundColor:"#576c89"
      height:2
      bottom:0

    header = Ti.UI.createView
      backgroundColor:"#e2e7ed"
      width:320
      height:60
    header.add border

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

    header.add arrow
    header.add statusLabel
    header.add lastUpdatedLabel
    header.add actInd

    table.headerPullView = header

    @lastRow = 0
    @table = table

    @header = {}
    @header.arrow = arrow
    @header.statusLabel = statusLabel
    @header.lastUpdatedLabel = lastUpdatedLabel
    @header.indicator = actInd
    # @header.show = () ->

    ## Paging用
    # navActInd = Ti.UI.createActivityIndicator()
    # @win.setLeftNavButton navActInd

    @pager = {}
    @pager.createRow = () ->
      Ti.UI.createTableViewRow
        title: "更新中…"
    # @pager.indicator = navActInd
    @pager.show = ()=>
      # @pager.indicator.show()
      @table.appendRow @pager.createRow()
    @pager.hide = ()=>
      @table.deleteRow @lastRow,
        animationStyle: Ti.UI.iPhone.RowAnimationStyle.NONE
      # @pager.indicator.hide()

  setFeed: (feed) ->
    Ti.API.debug "setFeed()"
    @table.setData feed.toRows(@win)
    @lastRow = feed.size()

  clear: () ->
    @table.setData []
    @lastRow = 0
    # loading = Ti.UI.createTableViewRow
    #   height: 40,
    #   backgroundColor: '#fff'

    # container = Ti.UI.createView
    #   layout: 'vertical'
    #   width: 320
    #   top: 0
    #   left: 0

    # label = Ti.UI.createLabel
    #   width: 'auto'
    #   height: 'auto'
    #   color: '#000'
    #   top: 0
    #   font:
    #     fontSize: 12
    # label.text = 'Loading...'

    # container.add label
    # loading.add container
    # @table.appendRow loading

  appendFeed: (feed) ->
    rows = feed.toRows(@win)
    _(rows).each (row) =>
      @table.appendRow row,
        animationStyle: Ti.UI.iPhone.RowAnimationStyle.NONE
    @lastRow += feed.size()
