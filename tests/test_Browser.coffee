# lib Soja.js
# lib ModelEditor.js
# lib ModelEditor.css
# lib DomHelper.js
# lib BrowserState.js
# lib Theme.js
# lib FileSystem.js
test_Browser = ->
    fs = new FileSystem
    
    cpt = 0

    a = ( d, n, m ) ->
        m._server_id = cpt += 1
        FileSystem._objects[ m._server_id ] = m
        d.push new File "toto", m._server_id
        m
    
    d = new Directory
    e = new Directory
    a d, "toto", new Model { toto: 10, tata: 20 }
    a d, "tata", new Model { toto: 11, tata: 22 }
    a d, "dir" , e
    a e, "titi", new Str "toto"
    
    editor = new_model_editor el: document.body, model: d
