TangleView = require './tangle-view'
{CompositeDisposable} = require 'atom'

module.exports = Tangle =
  tangleView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @tangleView = new TangleView(state.tangleViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @tangleView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'tangle:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @tangleView.destroy()

  serialize: ->
    tangleViewState: @tangleView.serialize()

  toggle: ->
    console.log 'Tangle was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
