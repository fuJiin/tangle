TangleView = require './tangle-view'
{CompositeDisposable} = require 'atom'

module.exports = Tangle =
  tangleView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->

    # Setup view
    #
    @tangleView = new TangleView(state.tangleViewState)

    # View bindings
    #
    @tangleView.on("click", @dismissModal.bind(this))
    @tangleView.on("blur", @dismissModal.bind(this))

    # Add view
    #
    @modalPanel = atom.workspace.addModalPanel(item: @tangleView[0])

    # Setup controller
    #
    @controller = new Controller(atom.workspace, @tangleView, @modalPanel)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    #
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace:not([mini])', 'tangle:connect': => @controller.connect()
    @subscriptions.add atom.commands.add 'atom-workspace:not([mini])', 'tangle:load-file': => @controller.loadFile()

  deactivate: ->
    @controller.disconnect()
    @modalPanel.destroy()
    @subscriptions.dispose()

  serialize: ->
    tangleViewState: @tangleView.serialize()

  dismissModal: ->
    @panel.hide()
