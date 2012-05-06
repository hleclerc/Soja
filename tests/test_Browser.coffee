# lib Soja.js
# lib ModelEditor.js
# lib ModelEditor.css
# lib DomHelper.js
# lib Theme.js
# lib FileSystem.js
# lib FileSystem.css
test_Browser = ->
    fs = new FileSystem
    FileSystem._disp = true

    fs.load "/test_browser", ( m, err ) ->
        if err
            m = new Directory
            r = new Directory
            fs.save "/test_browser", m
            fs.save "/test_browser/Result", r
            fs.save "/test_browser/Result/Hello", new Directory
            fs.save "/test_browser/Mesh", new Lst [ 1, 2 ]
            fs.save "/test_browser/Work", new Lst [ 1, 2 ]
            
            fun = ->
                fs.load "/test_browser", ( m, err ) ->
                    console.log m
                    
                    m[ 0 ]._info.add_attr
                        icon: "directory"
                        model_type: "Directory"
                        
                    m[ 1 ]._info.add_attr
                        model_type: "Mesh"
                        
                    m[ 2 ]._info.add_attr
                        model_type: "Directory"

                fs.load "/test_browser/Result", ( r, err ) ->
                    r[ 0 ]._info.add_attr
                        model_type: "Directory"
                        
                console.log "done"

            setTimeout fun, 1000
                        
            return
        
            
        ModelEditor.default_types.unshift ( model ) ->
            ModelEditorItem_Directory if model instanceof Directory
            
        editor = new_model_editor el: document.body, model: m

        
