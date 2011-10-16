HBFav ?= {}
HBFav.Util =
  count2label: (count) ->
    if count > 1 then "#{count} users" else "#{count} user"

  profileImageUrl: (name) ->
    "http://www.st-hatena.com/users/" + name.substr(0, 2) + "/#{name}/profile.gif"

  formatDate: ()->
    d = new Date()
    mon = d.getMonth()
    date = d.getDate()
    hour = d.getHours()
    min  = d.getMinutes()
    datestr = "#{mon}/#{date} #{hour}:#{min}"
    return datestr;

$$$ = HBFav.Util