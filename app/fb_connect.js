(function() {
  window.successURL = "https://www.facebook.com/connect/login_success.html";
  window.onFacebookLogin = function() {
    console.log("onFacebookLogin called");
    if (!false) {
      console.log("called");
      return chrome.tabs.getAllInWindow(null, function(tabs) {
        var i, params, _results;
        i = 0;
        console.log(tabs);
        console.log(successURL);
        _results = [];
        while (i < tabs.length) {
          console.log(tabs[i].url);
          console.log(tabs[i].url.indexOf(successURL));
          if (tabs[i].url.indexOf(successURL) === 0) {
            console.log("here");
            params = tabs[i].url.split("#")[1];
            console.log(params);
            localStorage.accessToken = params;
            chrome.tabs.onUpdated.removeListener(onFacebookLogin);
            return;
          }
          _results.push(i++);
        }
        return _results;
      });
    }
  };
  chrome.tabs.onUpdated.addListener(onFacebookLogin);
}).call(this);
