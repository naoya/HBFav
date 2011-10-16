HBFav ?= {}
HBFav.Util =
  count2label: (count) ->
    if count > 1 then "#{count} users" else "#{count} user"

  profileImageUrl: (name) ->
    "http://www.st-hatena.com/users/" + name.substr(0, 2) + "/#{name}/profile.gif"

$$$ = HBFav.Util