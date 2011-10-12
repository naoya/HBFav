express = require "express"
xml2js  = require 'xml2js'
_       = require "underscore"
request = require "request"
prettyDate = require "./pretty"

class Timeline
  constructor: (feed)->
    @title       = feed.channel.title
    @link        = feed.channel.link
    @description = feed.channel.description
    @bookmarks   = _(feed.item).map (item) ->
      new Timeline.Bookmark (item)

class Timeline.Bookmark
  constructor: (item)->
    @title       = item.title
    @link        = item.link
    @favicon_url = "http://favicon.st-hatena.com/?url=#{@link}"
    @comment     = item.description ? ""
    @count       = item['hatena:bookmarkcount']
    # @created_at  = new Date item['dc:date']
    @created_at  = prettyDate item['dc:date']
    @user        = new Timeline.User item['dc:creator']

class Timeline.User
  constructor: (@name) ->
    @profile_image_url = "http://www.st-hatena.com/users/" + @name.substr(0, 2) + "/#{@name}/profile.gif"

app = module.exports = express.createServer()
app.configure ->
  # app.set "views", __dirname + "/views"
  # app.set "view engine", "ejs"
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  # app.use express.static(__dirname + "/public")

app.configure "development", ->
  app.use express.errorHandler
    dumpExceptions: true
    showStack: true

app.configure "production", ->
  app.use express.errorHandler()

rss2timeline = (url, cb) ->
  parser = new xml2js.Parser()
  parser.addListener 'end', (result) ->
    cb new Timeline result

  request url, (error, response, body) ->
    console.log "[#{response.statusCode}] #{url}"
    if not error and response.statusCode is 200
      try
        parser.parseString body
      catch e
        # console.log response.statusCode
        console.log e

app.get "/:id", (req, res) ->
  offset = req.param('of') ? 0
  url = "http://b.hatena.ne.jp/#{req.params.id}/favorite.rss?of=#{offset}"
  rss2timeline url, (timeline) ->
    res.send timeline

app.get "/:id/bookmark", (req, res) ->
  offset = req.param('of') ? 0
  url = "http://b.hatena.ne.jp/#{req.params.id}/rss?of=#{offset}"
  rss2timeline url, (timeline) ->
    res.send timeline

app.listen 3000
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
