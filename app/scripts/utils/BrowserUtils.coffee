

class BrowserUtils

  @isMac: ->
    navigator.platform.indexOf "Mac" != -1

  @openWindow: (url)->
    console.log url
    window.open(url, "facebook_share_dialog")


module.exports = BrowserUtils

