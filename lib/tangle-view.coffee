{View} = require "atom-space-pen-views"

module.exports =

class TangleView extends View

  @content: ->
    @div id: "tangle-output", =>
      @span outlet: "messages", class: "message"

  showMessage: (msg) ->
    @message.empty()
    @message.append(msg)
