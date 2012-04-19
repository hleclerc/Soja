# lib gen/Soja.js
# lib gen/ModelEditor.js
# lib gen/ModelEditor.css
# lib gen/DomHelper.js
# lib gen/Color.js
# lib gen/Color.css
# lib gen/Geometry.js
# lib gen/BrowserState.js
# lib gen/CanvasManager.js
# lib gen/Animation.js
# lib gen/Theme.js
# lib gen/FileSystem.js
test_FileSystem = ->
    fs = new FileSystem

    # load
    m = new Model
    new_model_editor el: document.body, model: m, label: "model"
    
    l = ( n, d ) ->
        fs.load "/" + n, ( val, err ) ->
            if err
                val = Model.conv d
                console.log val
                fs.save "/" + n, Model.conv d
            m.add_attr n, val
        
    l "toto", 10
    #l "tata", "pouet"
    #l "titi", [ 1, 2 ]
    #l "mod"

    # load dir
    #fs.load "/", ( val, err ) ->
    #    console.log val.get()

    #
    new_dom_element
        parentNode: document.body
        nodeName: "button"
        onclick: -> m.titi.push 127
        txt: "push 127"
    new_dom_element
        parentNode: document.body
        nodeName: "button"
        onclick: -> m.mod.add_attr "pouet", "toz"
        txt: "add attr"
