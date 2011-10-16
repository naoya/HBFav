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
  },
  formatDate: function() {
    var d, datestr;
    d = new Date();
    datestr = d.getMonth() + '/' + d.getDate();
    if (d.getHours() >= 12) {
      datestr += ' ' + (d.getHours() === 12 ? d.getHours() : d.getHours() - 12 + ':' + d.getMinutes() + ' PM');
    } else {
      datestr += ' ' + d.getHours() + ':' + d.getMinutes()(+' AM');
    }
    return datestr;
  }
};
$$$ = HBFav.Util;