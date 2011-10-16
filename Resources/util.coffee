HBFav ?= {}
HBFav.Util =
  count2label: (count) ->
    if count > 1 then "#{count} users" else "#{count} user"

  profileImageUrl: (name) ->
    "http://www.st-hatena.com/users/" + name.substr(0, 2) + "/#{name}/profile.gif"

  formatDate: ()->
    d = new Date()

    datestr = d.getMonth() + '/' + d.getDate()

    if d.getHours() >= 12
      datestr += ' ' + if d.getHours() == 12 then d.getHours() else d.getHours() - 12 + ':' + d.getMinutes() + ' PM'
    else
      datestr += ' ' + d.getHours() + ':' + d.getMinutes() +' AM';
    return datestr;

$$$ = HBFav.Util