#this uses chrome api to look for a facebook window that contains the access token in the url

window.successURL = "https://www.facebook.com/connect/login_success.html"

window.onFacebookLogin = ->
  console.log("onFacebookLogin called")

  unless localStorage.accessToken
    
    chrome.tabs.getAllInWindow null, (tabs) ->
      i = 0
      
      while i < tabs.length
        if tabs[i].url.indexOf(successURL) is 0
        
          console.log("here")
          params = tabs[i].url.split("#")[1]
          
          x = params.split("&")[0]
          
          localStorage.accessToken = x.split("=")[1]
          
          console.log(localStorage.accessToken)
          
          chrome.tabs.onUpdated.removeListener onFacebookLogin
          
          return
        i++
        

chrome.tabs.onUpdated.addListener onFacebookLogin