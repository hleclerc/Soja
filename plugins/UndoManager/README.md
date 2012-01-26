`UndoManager` basically permits to

* make snapshot of a model (which can be a set of models)
* rewind to previous(es) snapshot
* and unwind

`UndoManager` works with plugins like `ModelEditor` or `CanvasManager`, where `snapshot` is called before each "important" action.

This is a exemple borrowed from the `tests` directory :

```coffeescript
# data
m = new Model
    l: [ 666 ]
    b: 1
    t: new ConstrainedVal( 1, min: 0, max: 10 )
    z: "toto"

# undo manager
a = new UndoManager m

# some controllers
add_butt = ( txt, fun ) ->
    new_dom_element
        parentNode: document.body
        nodeName  : "input"
        type      : "button"
        value     : txt
        onclick   : fun
add_butt "undo", -> a.undo()
add_butt "redo", -> a.redo()

# view
new_model_editor el: document.body, model: m, label: "test model", undo_manager: a
```