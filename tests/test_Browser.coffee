# lib Soja.js
# lib ModelEditor.js
# lib ModelEditor.css
# lib DomHelper.js
# lib Theme.js
# lib FileSystem.js
test_Browser = ->
    fs = new FileSystem

    disp = ( m ) ->
        for f in m
            f._info.add_attr
                icon: "icon"
        
        console.log m
        new_model_editor el: document.body, model: m
    
    fs.load "/test_browser", ( m, err ) ->
        if err
            fs.save "/test_browser", new Directory
            fs.save "/test_browser/toto", new Lst [ 1, 2 ]
            fs.save "/test_browser/tata", new Lst [ 1, 2 ]
            
            fs.load "/test_browser", ( m, err ) ->
                if err
                    console.log "Bing"
                disp m
        else
            disp m
        
