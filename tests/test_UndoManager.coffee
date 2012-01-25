# lib gen/Soja.js
# lib gen/DomHelper.js
# lib gen/ModelEditor.js
# lib gen/ModelEditor.css
# lib gen/UndoManager.js

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
        b: 1
        t: new ConstrainedVal( 1, min: 0, max: 10 )
        z: "toto"
    
    # undo manager
    a = new UndoManager m
    add_butt "undo", -> a.undo()
    add_butt "redo", -> a.redo()

    # view
    new_model_editor el: document.body, model: m, label: "test model", undo_manager: a
