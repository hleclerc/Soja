# lib Soja.js
# lib DomHelper.js
# lib ModelEditor.js
# lib ModelEditor.css
# lib UndoManager.js

test_UndoManager = ->
    add_butt = ( txt, fun ) ->
        new_dom_element
            parentNode: document.body
            nodeName  : "input"
            type      : "button"
            value     : txt
            onclick   : fun

    # data
    m = new Model
        l: [ 666 ]
        #         b: 1
        #         t: new ConstrainedVal( 1, min: 0, max: 10 )
        #         z: "toto"
    
    # undo manager
    a = new UndoManager m
    add_butt "undo", -> a.undo()
    add_butt "redo", -> a.redo()
    add_butt "crea", ->
        a.snapshot()
        m.l.push m.l.length

    # view
    new_model_editor el: document.body, model: m, label: "test model", undo_manager: a
