(function() {
  window.successURL = "https://www.facebook.com/connect/login_success.html";
  window.onFacebookLogin = function() {
    console.log("onFacebookLogin called");
    if (!false) {
      return chrome.tabs.getAllInWindow(null, function(tabs) {
        var i, params, x, _results;
        i = 0;
        _results = [];
        while (i < tabs.length) {
          if (tabs[i].url.indexOf(successURL) === 0) {
            console.log("here");
            params = tabs[i].url.split("#")[1];
            x = params.split("&")[0];
            localStorage.accessToken = x.split("=")[1];
            console.log(localStorage.accessToken);
            chrome.tabs.onUpdated.removeListener(onFacebookLogin);
            window.get_stream();
            window.get_wall();
            window.get_friends();
            return;
          }
          _results.push(i++);
        }
        return _results;
      });
    }
  };
  window.update_ui_login = function(login) {
    if (login === true) {
      return console.log("login ui modifications");
    } else {
      return console.log("logout ui modifications");
    }
  };
  chrome.tabs.onUpdated.addListener(onFacebookLogin);
}).call(this);
