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
    return "http://www.st-hatena.com/users/" + name.substr(0, 2) + ("/" + name + "/profile_l.gif");
  },
  profileImageUrlLarge: function(name) {
    return "http://www.st-hatena.com/users/" + name.substr(0, 2) + ("/" + name + "/profile.gif");
  },
  formatDate: function() {
    var d, date, datestr, hour, min, mon;
    d = new Date();
    mon = d.getMonth();
    date = d.getDate();
    hour = d.getHours();
    min = d.getMinutes();
    datestr = "" + mon + "/" + date + " " + hour + ":" + min;
    return datestr;
  }
};
$$$ = HBFav.Util;