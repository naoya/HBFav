Ti.include '/lib/sprintf.js'

HBFav ?= {}
HBFav.Util =
  count2label: (count) ->
    if count > 1 then "#{count} users" else "#{count} user"

  profileImageUrl: (name) ->
    "http://www.st-hatena.com/users/" + name.substr(0, 2) + "/#{name}/profile_l.gif"

  profileImageUrlLarge: (name) ->
    "http://www.st-hatena.com/users/" + name.substr(0, 2) + "/#{name}/profile.gif"

  formatDate: ()->
    d = new Date()
    mon = d.getMonth()
    date = d.getDate()
    hour = d.getHours()
    min  = d.getMinutes()
    datestr = sprintf "%02d/%02d %02d:%02d", mon + 1, date, hour, min
    # datestr = "#{mon}/#{date} " + String.format ""#{hour}:#{min}"
    return datestr;

$$$ = HBFav.Util