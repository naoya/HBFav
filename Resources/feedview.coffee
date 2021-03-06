Ti.include 'feed.js'
Ti.include 'util.js'

class AbstractState
  toString : () ->  'AbstractState'
  constructor: (@feedView) ->
  getFeed : (url) ->
    self = @
    onload = @.onload
    onerror = @.onerror

    xhr = Ti.Network.createHTTPClient()
    xhr.timeout = 30000
    xhr.open 'GET', url
    xhr.onload = ->
      data = JSON.parse @.responseText
      onload.apply(self, [ data ])

      xhr.onload = null
      xhr.onerror = null
      xhr = null
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
      offset = e.contentOffset.y;
      height   = e.size.height
      total    = offset + height
      theEnd   = e.contentSize.height
      distance = theEnd - total
      if distance < @lastDistance
        nearEnd = theEnd * .98
        if total >= nearEnd and @feedView.lastRow > 5
          @feedView.transitState new PagingStartState @feedView
      @lastDistance = distance
  # scrollEnd: (e) ->
  #   ## paging
  #   offset = e.contentOffset.y;
  #   height   = e.size.height
  #   total    = offset + height
  #   theEnd   = e.contentSize.height
  #   distance = theEnd - total
  #   if distance < @lastDistance
  #     nearEnd = theEnd * .90
  #     if total >= nearEnd
  #       @feedView.transitState new PagingStartState @feedView
  #   @lastDistance = distance

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
  onerror: (err) ->
    @feedView.showFailure()
    ## FIXME: not DRY (1)
    @feedView.table.setContentInsets({top:0},{animated:true})
    @feedView.header.lastUpdatedLabel.text = "最後の更新: " + $$$.formatDate()
    @feedView.header.statusLabel.text = "画面を引き下げて…";
    @feedView.header.indicator.hide()
    @feedView.header.arrow.show()
    @feedView.transitState new NormalState @feedView

class ReloadEndState extends AbstractState
  toString : () -> "ReloadEndState"
  constructor: (@feedView, @data) ->
  execute : () ->
    feed = new Feed @data
    @feedView.setFeed feed

    ## FIXME: not DRY (1)
    @feedView.table.setContentInsets({top:0},{animated:true})
    @feedView.header.lastUpdatedLabel.text = "最後の更新: " + $$$.formatDate()
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
  onerror: (err) ->
    @feedView.showFailure()

    i = @feedView.lastRow
    @feedView.pager.hide(i)
    @feedView.transitState new NormalState @feedView

class PagingEndState extends AbstractState
  toString: () -> "PagingEndState"
  constructor: (@feedView, @data) ->
  execute: () ->
    i = @feedView.lastRow

    feed = new Feed @data
    @feedView.appendFeed feed
    @feedView.pager.hide(i)
    @feedView.transitState new NormalState @feedView

class InitStartState extends AbstractState
  toString : () -> "InitStartState"
  constructor: (@feedView) ->
  execute: () ->
    loadingRow = Ti.UI.createTableViewRow
      height: 44
    loadingInd = Ti.UI.createActivityIndicator
      backgroundColor: "#fff"
      top: 10
      bottom: 10
      style: Ti.UI.iPhone.ActivityIndicatorStyle.DARK
    loadingInd.show()
    loadingRow.add loadingInd
    @feedView.table.setData [ loadingRow ]

    @.getFeed @feedView.url
  onload : (data) ->
    @feedView.transitState new InitEndState @feedView, data
  onerror : (err) ->
    @feedView.showFailure()
    @feedView.clear()
    @feedView.transitState new NormalState @feedView

# class InitErrorState extends AbstractState
#   toString : () -> "InitErrorState"
#   constructor: (@feedView) ->
#   execute: () ->
#     @feedView.table.setData []

class InitEndState extends AbstractState
  toString : () -> "InitEndState"
  constructor: (@feedView, @data) ->
  execute : () ->
    feed = new Feed @data
    @feedView.setFeed feed
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
    table = Ti.UI.createTableView
      data: []

    table.addEventListener 'click', (e) ->
      row = e.rowData
      if row.bookmark
        Ti.UI.currentTab.open Ti.UI.createWindow
          url: 'permalink.js'
          title: 'ブックマーク'
          bookmark: row.bookmark

    table.addEventListener 'scroll', (e) =>
      @state.scroll e
    table.addEventListener 'scrollEnd', (e) =>
      @state.scrollEnd e

    @win.add table

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
      backgroundColor:"#e2e7ed"
      backgroundImage:"./images/whiteArrow.png"
      width:23
      height:60
      bottom:10
      left:20

    statusLabel = Ti.UI.createLabel
      backgroundColor:"#e2e7ed"
      text: "画面を引き下げて…"
      left:55
      width:200
      bottom:30
      height: Ti.UI.SIZE
      color:"#576c89"
      textAlign:"center"
      font:
        fontSize:14
        fontWeight:"bold"
      shadowColor:"#fff"
      shadowOffset:
        x:0
        y:1

    lastUpdatedLabel = Ti.UI.createLabel
      backgroundColor:"#e2e7ed"
      text: "最後の更新: " + $$$.formatDate()
      left:55
      width:200
      bottom:15
      height: Ti.UI.SIZE
      color:"#576c89"
      textAlign:"center"
      font:
        fontSize:12
      shadowColor:"#fff"
      shadowOffset:
        x:0
        y:1

    actInd = Titanium.UI.createActivityIndicator
      backgroundColor:"#e2e7ed"
      style: Ti.UI.iPhone.ActivityIndicatorStyle.DARK
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
    @pager = {}
    @pager.createRow = () ->
      row = Ti.UI.createTableViewRow
        height: 44
        # height: Ti.UI.SIZE
      ind = Ti.UI.createActivityIndicator
        top: 10
        bottom: 10
        style: Ti.UI.iPhone.ActivityIndicatorStyle.DARK
      row.add ind
      ind.show()
      row
    @pager.show = ()=>
      @table.appendRow @pager.createRow()
    @pager.hide = (index)=>
      @table.deleteRow index,
        animationStyle: Titanium.UI.iPhone.RowAnimationStyle.NONE

  setFeed: (feed) ->
    @table.setData feed.toRows()
    @lastRow = feed.size()

  clear: () ->
    @table.setData []
    @lastRow = 0

  showFailure: () ->
    dialog = Ti.UI.createAlertDialog
      title: "エラー"
      message: "フィードを取得できません"
    dialog.show()

  appendFeed: (feed) ->
    rows = feed.toRows()
    # current = @table.data
    # sec = Ti.UI.createTableViewSection()
    # rows?.forEach (row) ->
    #   sec.add row
    # current.push sec
    # @table.setData current

    @table.appendRow rows
    @lastRow += feed.size()
