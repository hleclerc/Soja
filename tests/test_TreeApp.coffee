# lib gen/Soja.js
# lib gen/DomHelper.js
# lib gen/TreeView.js
# lib gen/TreeView.css
# lib gen/BrowserState.js
# lib gen/LayoutManager.js
# lib gen/ModelEditor.js
# lib gen/ModelEditor.css
# lib gen/Color.js
# lib gen/Color.css
# lib gen/Geometry.js
# lib gen/UndoManager.js
# lib gen/CanvasManager.js
# lib gen/TreeApp.js
# lib gen/TreeApp.css

test_TreeApp = ->
    m = new TreeAppData
    m.modules.push new TreeAppModule_PanelManager
    m.modules.push new TreeAppModule_UndoManager 
    m.modules.push new TreeAppModule_Sketch
    
    v = new TreeApp document.body, m

    
    m.new_session "Session 1"
