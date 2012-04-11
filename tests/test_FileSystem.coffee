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

    m = new Model
    new_model_editor el: document.body, model: m, label: "model"
    
    fs.load "/toto", ( val ) ->
        m.add_attr toto: val
        
    # setTimeout ( -> m.toto.set 150 ), 1000
    
    # 
    #     fs.save "/home/monkey/session/12345689", tree_app.session
        