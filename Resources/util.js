var $$$;
if (typeof HBFav === "undefined" || HBFav === null) {
  HBFav = {};
}
HBFav.Util = {
  count2label: function(count) {
    if (count > 1) {
      return "" + count + " users";
    } else {
      return "" + count + " user";
    }
  },
  profileImageUrl: function(name) {
    return "http://www.st-hatena.com/users/" + name.substr(0, 2) + ("/" + name + "/profile.gif");
  }
};
$$$ = HBFav.Util;