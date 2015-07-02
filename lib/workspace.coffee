module.exports =

class Workspace

  constructor: (@workspace) ->
    @editor = @workspace.getActiveTextEditor()

  fileContents: ->
    @editor.getText()

  filePath: ->
    @editor.getPath()

  fileName: ->
    @editor.getTitle()
