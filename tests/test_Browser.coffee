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
            m = new Directory
            fs.save "/test_browser", m
            fs.save "/test_browser/Result", new Directory
            fs.save "/test_browser/Result/Hello", new Directory
            fs.save "/test_browser/Mesh", new Lst [ 1, 2 ]
            fs.save "/test_browser/Work", new Lst [ 1, 2 ]

        m[ 0 ]._info.add_attr
            icon: "directory"
            model_type: "Directory"
            
        m[ 1 ]._info.add_attr
            model_type: "Mesh"
            
        m[ 2 ]._info.add_attr
            model_type: "Directory"
            
        fs.load "/test_browser/Result", ( m, err ) ->
            m[ 0 ]._info.add_attr
                model_type: "Directory"
            console.log "<->", m[ 0 ]
            
            fs.load "/test_browser/Result", ( m, err ) ->
                console.log "<-->", m[ 0 ]._info.model_type.get()
        
        fs.load "/test_browser/Result", ( s, err ) ->
            console.log "->", s
            s[ 0 ]._info.add_attr
                model_type: "Directory"
        
        ModelEditor.default_types.unshift ( model ) ->
            ModelEditorItem_Directory if model instanceof Directory
            
        editor = new_model_editor el: document.body, model: m

        
