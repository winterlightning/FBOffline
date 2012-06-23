(function() {
  window.fb_match = {
    profile: {
      url: "/me",
      method: "GET"
    }
  };
  window.fb_base = "https://graph.facebook.com";
  window.fb_call = function(obj, cb) {
    var params;
    params = {};
    params.method = obj.method;
    params.access_token = localStorage.accessToken;
    return $.getJSON("https://graph.facebook.com" + obj.url, params, function(res) {
      console.log(res);
      if (cb != null) {
        return cb(res);
      }
    });
  };
}).call(this);
