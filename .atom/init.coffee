atom.commands.add 'atom-text-editor',
'custom:close-panes', ->
    panes = atom.workspace.getPaneItems()
    activePane = atom.workspace.getActivePane()
    for pane in panes
        pane.destroy() if activePane isnt pane
