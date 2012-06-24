(function() {
  window.fb_match = {
    profile: {
      url: "/me",
      method: "GET"
    },
    newsfeed: {
      url: "/me/home",
      method: "GET"
    },
    wall: {
      url: "/me/feed",
      method: "GET"
    },
    friends: {
      url: "/me/friends"
    }
  };
  window.fb_base = "https://graph.facebook.com";
  window.fb_call = function(obj, cb, tag) {
    var params;
    params = {};
    params.access_token = localStorage.accessToken;
    return $.getJSON("https://graph.facebook.com" + obj.url, params, function(res) {
      console.log(res);
      window.fb_data = res;
      if (cb != null) {
        if (tag != null) {
          return cb(res, tag);
        } else {
          return cb(res);
        }
      }
    });
  };
}).call(this);
