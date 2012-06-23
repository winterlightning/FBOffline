(function() {
  window.onFacebookLogin = function() {
    console.log("onFacebookLogin called");
    if (!localStorage.accessToken) {
      return chrome.tabs.getAllInWindow(null, function(tabs) {
        var i, params, _results;
        i = 0;
        _results = [];
        while (i < tabs.length) {
          if (tabs[i].url.indexOf(successURL) === 0) {
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
  window.successURL = "https://www.facebook.com/connect/login_success.html";
  chrome.tabs.onUpdated.addListener(onFacebookLogin);
}).call(this);
