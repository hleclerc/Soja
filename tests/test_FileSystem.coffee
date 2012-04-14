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

    # fs.save "/home/monkey/session/12345689", tree_app.session
    
    
    # load
    m = new Model
    new_model_editor el: document.body, model: m, label: "model"
    
    l = ( n ) ->
        fs.load "/" + n, ( val ) ->
            m.add_attr n, val
        
    l "toto"
    l "tata"
    l "titi"
    l "mod"

    # load dir
    fs.load "/", ( val ) ->
        console.log val.get()
        
    # load dir
    fs.save "/saved", new Val( 10 )

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
    # setTimeout ( -> m.toto.set 150 ), 1000
    
    # 
        