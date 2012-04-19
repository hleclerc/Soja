# lib Soja.js
# lib DomHelper.js
# lib TreeView.js
# lib TreeView.css
# lib BrowserState.js
# lib LayoutManager.js
# lib ModelEditor.js
# lib ModelEditor.css
# lib Color.js
# lib Color.css
# lib Geometry.js
# lib UndoManager.js
# lib CanvasManager.js
# lib TreeApp.js
# lib TreeApp.css

test_TreeApp = ->
    m = new TreeAppData
    m.modules.push new TreeAppModule_PanelManager
    m.modules.push new TreeAppModule_UndoManager 
    m.modules.push new TreeAppModule_Sketch
    
    v = new TreeApp document.body, m

    
    m.new_session "Session 1"
