fs        = require "fs"
path      = require "path"
Workspace = require "./workspace"
Client    = require "nrepl-client"

module.exports =

class Controller

  constructor: (@workspace, @view, @panel) ->
    @workspace = new Workspace(@workspace)
    @directory = atom.project.getDirectories()[0]
    @connected = false
    @conn      = null

  connect: ->
    if !@connected
      @showMessage("Connecting...")

      @withREPLPort this, (port) =>
        if port
          @showMessage("Connecting to nREPL on port " + port + "...")
          @conn = Client.connect({ port: port })

          @subscribeErrors(@conn)
          @subscribeConnect(@conn)
        else
          @showMessage("No nREPL server detected")
    else
      @showMessage("Already connected!")

    subscribeErrors: (conn) ->
      conn.on "error", (err) =>
        @showMessage("Error in nREPL client connection: " + err)

    subscribeConnect: (conn) ->
      conn.once "connect", (err) =>
        @connected = true
        @showMessage("nREPL connected!")

    disconnect: ->
      if @connected
        @conn.close()

    loadFile: ->
      if @connected
        @showMessage("Loading file...")
        @conn.loadFile(
          @workspace.filecontents(),
          @workspace.fileName(),
          @workspace.filePath(),
          (resp) =>
            @showMessage(resp)
        )
      else
        @showMessage("No connection detected. Connect to nREPL first")

    showMessage: (msg) ->
      if @view && @panel
        @view.showMessage(msg)
        @panel.show()

    withREPLPort: (self, fn) ->
      portFilePath = path.join(self.directory.getPath(), ".nrepl-port")

      fs.exists portFilePath, (result) ->
        if result
          fs.readFile portFilePath, (err, content) ->
            fn(content and parseInt(content))
        else
          fn(null)
