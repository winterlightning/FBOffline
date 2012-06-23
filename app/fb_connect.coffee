#this uses chrome api to look for a facebook window that contains the access token in the url

window.successURL = "https://www.facebook.com/connect/login_success.html"

window.onFacebookLogin = ->
  console.log("onFacebookLogin called")

  unless false
    console.log("called")
    
    chrome.tabs.getAllInWindow null, (tabs) ->
      i = 0
      console.log(tabs)
      console.log(successURL)
      
      while i < tabs.length
        console.log(tabs[i].url)
        console.log( tabs[i].url.indexOf(successURL) )
        if tabs[i].url.indexOf(successURL) is 0
        
          console.log("here")
          params = tabs[i].url.split("#")[1]
          console.log params
          localStorage.accessToken = params
          chrome.tabs.onUpdated.removeListener onFacebookLogin
          
          return
        i++
        

chrome.tabs.onUpdated.addListener onFacebookLogin