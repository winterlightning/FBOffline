#this uses chrome api to look for a facebook window that contains the access token in the url

window.successURL = "https://www.facebook.com/connect/login_success.html"

window.onFacebookLogin = ->
  console.log("onFacebookLogin called")

  unless localStorage.accessToken 
    
    chrome.tabs.getAllInWindow null, (tabs) ->
      i = 0
      
      while i < tabs.length
        if tabs[i].url.indexOf(successURL) is 0
        
          console.log("here", tabs[i])
          params = tabs[i].url.split("#")[1]
          
          x = params.split("&")[0]
          
          
          localStorage.accessToken = x.split("=")[1]
          
          console.log(localStorage.accessToken)
          
          chrome.tabs.onUpdated.removeListener onFacebookLogin
          
          $("#loading").hide()
          chrome.tabs.remove(tabs[i].id)
          
          #window.get_stream()
          #window.get_wall()
          #window.get_friends()
          
          return
        i++
        
#update the ui after login or logout
window.update_ui_login = (login) ->
  
  if login is true
    console.log("login ui modifications")
  else
    console.log("logout ui modifications")

chrome.tabs.onUpdated.addListener onFacebookLogin