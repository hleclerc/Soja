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
            fs.load "/", ( d, err ) ->
                m = new Directory
                d.save "test_browser", m
                d.save "Result", new Directory
                # d.save "Result/Hello", new Directory
                d.save "Mesh", new Lst [ 1, 2 ]
                d.save "Work", new Lst [ 1, 2 ]
                
                new_model_editor el: document.body, model: m
        else
            new_model_editor el: document.body, model: m
