# lib Soja.js
# lib ModelEditor.js
# lib ModelEditor.css
# lib DomHelper.js
# lib Theme.js
# lib FileSystem.js
test_Browser = ->
    fs = new FileSystem
    FileSystem._disp = true

    fs.load "/test_browser", ( m, err ) ->
        if err
            fs.load "/", ( d, err ) ->
                t = new Directory
                d.add "test_browser", t
                t.add "tata", new Lst [ 1, 2 ]
                t.add "teta", new Lst [ 3, 4 ]
            
        for f in m
            f._info.add_attr
                icon: "icon"
                
        m.bind ->
            console.log m
            
        new_model_editor el: document.body, model: m
            
