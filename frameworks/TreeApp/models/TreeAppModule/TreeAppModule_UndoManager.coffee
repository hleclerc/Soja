#
class TreeAppModule_UndoManager extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'History'
        
        @actions.push
            ico: "img/undo.png"
            siz: 2
            txt: "Undo"
            fun: ( evt, app ) -> app.undo_manager.undo()
            key: [ "Ctrl+Z" ]
            
        @actions.push
            ico: "img/redo.png"
            siz: 2
            txt: "Redo"
            fun: ( evt, app ) -> app.undo_manager.redo()
            key: [ "Ctrl+Shift+Z" ]
        