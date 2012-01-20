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
        style     : { position: "fixed", top: 0, left: 0, width: "70%", bottom: 0 }

    c = new CanvasManager el: d
    
    # BACKGROUND
    c.items.push new Background

    # MESH
    m = new Mesh
    s = 800
    m.add_point [ 0, 0, 0 ]
    m.add_point [ s, 0, 0 ]
    m.add_point [ s, s, 0 ]
    m.add_point [ 0, s, 0 ]
    m.lines.push [ 0, 1 ]
    m.lines.push [ 1, 2, 3 ]
    m.lines.push [ 3, 0 ]
    #     m.displayed_field.lst.set [ "", "nodal" ]
    #     m.displayed_field.set 1
    
    #     m.nodal_fields.set
    #         nodal: [ 1, 0.5, 0 ]
    # m.lines.push [ 0, 1 ]
    # m.lines.push [ 1, 3, 2 ]
    # m.lines.push [ 2, 0 ]
    
    #     m.gradient.add_color [ 0, 0, 0, 255 ], 0
    #     m.gradient.add_color [ 255, 255, 255, 255 ], 1
    c.selected_items.push [ m ]
    c.items.push m
    
    # IMG
    c.items.push new Img "http://www.tao-yin.com/acupuncture/img/soja_totum1.jpg"
    
    # AXES
    c.items.push new Axes

    
    # redraw if window resize
    browser_state = new BrowserState
    browser_state.bind ->
        c.resize 0.7 * browser_state.window_size[ 0 ], browser_state.window_size[ 1 ]
        c.draw()

    #
    c.fit()
    
    
    # editor
    d = new_dom_element
        parentNode: document.body
        style     : { position: "fixed", top: 0, left: "70%", right: 0, bottom: 0 }
    e = new_model_editor
        el    : d, 
        model : c.cam,
        label : "Cam data"

    new_dom_element
        parentNode: d
        nodeName : "input"
        type     : "button"
        value    : "Delete selected points"
        onclick: -> m.delete_selected_point c.cam_info
        

    new_dom_element
        parentNode: d
        nodeName  : "input"
        type      : "button"
        value     : "Round selected points"
        onclick   : -> m.make_curve_line_from_selected c.cam_info
        

   