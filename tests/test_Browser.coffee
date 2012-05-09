# lib Soja.js
# lib ModelEditor.js
# lib ModelEditor.css
# lib DomHelper.js
# lib Theme.js
# lib FileSystem.js
# lib FileSystem.css
test_Browser = ->
    fs = new FileSystem
    FileSystem._disp = false

    fs.load "/test_browser", ( m, err ) ->
        if err
            fs.load "/", ( d, err ) ->
                console.log "MAKE"
                m = new Directory
                d.add_file "test_browser", m, model_type: "Directory"
                t = new Directory
                m.add_file "Result", t, model_type: "Directory"
                t.add_file "Steel", ( new Directory ), model_type: "Directory"
                t.add_file "Steel", ( new Lst [ 1, 2 ] ), model_type: "Mesh"
                m.add_file "Mesh", ( new Lst [ 1, 2 ] ), model_type: "Mesh"
                m.add_file "Work", ( new Lst [ 1, 2 ] ), model_type: "Mesh"
                
                new_model_editor el: document.body, model: m
        else
            new_model_editor el: document.body, model: m
