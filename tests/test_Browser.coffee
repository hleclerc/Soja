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
test_Browser = ->
    fs = new FileSystem

    m = new Model
        toto: 10
        tata: 20
    m._server_id = 1
    FileSystem._objects[ m._server_id ] = m
    
    d = new Directory
    d.push new File "toto", m._server_id
    
    editor = new_model_editor el: document.body, model: d
