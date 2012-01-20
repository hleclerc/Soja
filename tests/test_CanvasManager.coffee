# lib gen/Soja.js
# lib gen/ModelEditor.js
# lib gen/ModelEditor.css
# lib gen/DomHelper.js
# lib gen/Color.js
# lib gen/Geometry.js
# lib gen/BrowserState.js
# lib gen/CanvasManager.js
test_CanvasManager = ->
    d = new_dom_element
        parentNode: document.body
        style     : { position: "absolute", top: 0, left: 0, width: "70%", bottom: 0 }

    c = new CanvasManager el: d
    c.items.push new Background
    
    m = new Mesh
    m.points.push [ 0, 0, 0 ]
    m.points.push [ 1, 0, 0 ]
    m.points.push [ 0, 1, 0 ]
    m.triangles.push [ 0, 1, 2 ]
    
    m.displayed_field.lst.set [ "", "nodal" ]
    m.displayed_field.set 1
    
    m.nodal_fields.set
        nodal: [ 1, 0.5, 0 ]
    # m.lines.push [ 0, 1 ]
    # m.lines.push [ 1, 3, 2 ]
    # m.lines.push [ 2, 0 ]
    
    m.gradient.add_color [ 0, 0, 0, 255 ], 0
    m.gradient.add_color [ 255, 255, 255, 255 ], 1
    
    c.items.push m
    
    
    c.items.push new Axes
    
    browser_state = new BrowserState
    browser_state.bind ->
        c.resize browser_state.window_size[ 0 ], browser_state.window_size[ 1 ]
        c.draw()
    
    c.fit()
    
    # editor
    d = new_dom_element
        parentNode: document.body
        style     : { position: "absolute", top: 0, left: "70%", right: 0, bottom: 0 }
    e = new_model_editor
        el    : d, 
        model : c.cam,
        label : "cam"

    new_dom_element
        parentNode: d
        nodeName : "input"
        type : "button"
        value : "Delete"
        onclick: -> m.deleteSelectedPoint(c.cam_info)
        

    new_dom_element
        parentNode: d
        nodeName : "input"
        type : "button"
        value : "Make Curve line"
        onclick: -> m.makeCurveLineFromSelected(c.cam_info)
        

   