# lib Soja.js
# lib ModelEditor.js
# lib ModelEditor.css
# lib DomHelper.js
# lib Color.js
# lib Color.css
# lib Geometry.js
# lib BrowserState.js
# lib CanvasManager.js
# lib Animation.js
# lib Theme.js
# lib FileSystem.js
test_FileSystem = ->
    FileSystem._disp = true
    fs = new FileSystem

    # load
    m = new Model
    new_model_editor el: document.body, model: m, label: "model"
    
    l = ( n, d ) ->
        fs.load "/" + n, ( val, err ) ->
            if err
                val = Model.conv d
                fs.save "/" + n, val
            else
                console.log "load ->", val.get()
            m.add_attr n, val
        
    l "toto", 10
    l "tete", new ConstrainedVal 0, { min:0, max:100 }
    l "tata", "pouet"
    l "titi", [ 1, 2 ]
    l "coul", new Color
    l "mod", {}

    # load dir
    #fs.load "/", ( val, err ) ->
    #    console.log val.get()

    #
    cpt = 0
    new_dom_element
        parentNode: document.body
        nodeName: "button"
        onclick: -> m.titi.push 127
        txt: "push 127"
    new_dom_element
        parentNode: document.body
        nodeName: "button"
        onclick: -> m.mod.add_attr "attr_#{cpt += 1}", "toz"
        txt: "add attr"
