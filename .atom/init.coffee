atom.commands.add 'atom-text-editor',
<<<<<<< HEAD
'custom:close-panes', ->
=======
'custom:close-other-panes', ->
>>>>>>> 2d2a54f... merge conflict fix on git stash pop: ugh i need to sync more
    panes = atom.workspace.getPaneItems()
    activePane = atom.workspace.getActivePane()
    for pane in panes
        pane.destroy() if activePane isnt pane
