window.onFacebookLogin = ->
  console.log("onFacebookLogin called")

  unless localStorage.accessToken
    chrome.tabs.getAllInWindow null, (tabs) ->
      i = 0

      while i < tabs.length
        if tabs[i].url.indexOf(successURL) is 0
          params = tabs[i].url.split("#")[1]
          console.log params
          localStorage.accessToken = params
          chrome.tabs.onUpdated.removeListener onFacebookLogin
          return
        i++
        
window.successURL = "https://www.facebook.com/connect/login_success.html"
chrome.tabs.onUpdated.addListener onFacebookLogin