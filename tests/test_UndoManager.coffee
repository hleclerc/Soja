# lib gen/Soja.js
# lib gen/DomHelper.js
# lib gen/ModelEditor.js
# lib gen/ModelEditor.css
# lib gen/UndoManager.js

test_UndoManager = ->
    m = new Model
        l: [ 666 ]
        b: 1
        #         t: new ConstrainedVal( 1,
        #             min: 0
        #             max: 10
        #         )
        #z: "toto"
    
    a = new UndoManager m

    new_dom_element
        parentNode: document.body
        nodeName  : "input"
        type      : "button"
        value     : "add c"
        onclick   : ->
            a.snapshot()
            m.add_attr
                c: 663
    
    new_dom_element
        parentNode: document.body
        nodeName  : "input"
        type      : "button"
        value     : "add"
        onclick   : ->
            a.snapshot()
            m.l.push m.l.length
    
    new_dom_element
        parentNode: document.body
        nodeName  : "input"
        type      : "button"
        value     : "pop"
        onclick   : ->
            a.snapshot()
            m.l.pop()
    
    new_dom_element
        parentNode: document.body
        nodeName  : "input"
        type      : "button"
        value     : "undo"
        onclick   : -> a.undo()
    
    new_dom_element
        parentNode: document.body
        nodeName  : "input"
        type      : "button"
        value     : "redo"
        onclick   : -> a.redo()

    new_model_editor el: document.body, model: m, label: "test model", undo_manager: a


#     f = new ModelEditor document.body, m
#     f.undo_manager = a
#     f.render()
