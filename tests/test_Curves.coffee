# lib gen/Soja.js
# lib gen/ModelEditor.js
# lib gen/ModelEditor.css
# lib gen/DomHelper.js
# lib gen/Color.js
# lib gen/Color.css
# lib gen/Geometry.js
# lib gen/BrowserState.js
# lib gen/CanvasManager.js
# lib gen/Animation.js
# lib gen/Theme.js

test_Curves = ->
        
    d = new_dom_element
        parentNode: document.body
        style     : { position: "fixed", top: 0, left: 0 }
        
    c = new CanvasManager
        el: d
        want_aspect_ratio: true
        padding_ratio: 1.4
        constrain_zoom: 'x'
        auto_fit: new Bool true
        
    c.cam.threeD.set false
    c.resize 700, 400

    m = new Graph 
        marker: 'dot',
        marker_color: "#f00"
        line_width  : 3,
        line_color: new Color 75, 150, 175
        size_marker: 10,
        x_axis: 'label X',
        y_axis: 'label Y'
        
        
    m.points.push [   0, 0.045245, 0 ]
    m.points.push [ 100, 0.08454, 0 ]
    m.points.push [ 200, 0.0013, 0 ]
    m.points.push [ 255, 0.0009154, 0 ]
    
    c.items.push m
    c.fit 0
    c.draw()
    
    g = new_dom_element
        parentNode: document.body
        style     : { position: "fixed", top: 0, left: 800 }
    editor = new_model_editor el: g, model: m, label: "Simple Graph", item_width: 48
    editor.default_types.push ( model ) -> ModelEditorItem_Bool_Img       if model instanceof Bool
    
    new_model_editor el: g, model: c.cam, label: "cam", item_width: 48
    new_model_editor el: g, model: c.theme, label: "theme", item_width: 48
    
    #-------------------
    
    d = new_dom_element
        parentNode: document.body
        style     : { position: "fixed", top: 400, left: 0, width: 700, height: 300 }
        
    c = new CanvasManager el: d, want_aspect_ratio: true, padding_ratio: 1.4, constrain_zoom: 'x'
    c.cam.threeD.set false
    c.resize 700, 300

    # BarChart
    m = new Graph 
        marker: 'bar',
        marker_color: new Color 255, 0, 0
        shadow: false,
        size_marker: 2,
        show_line: false,
        show_grid: false,
        x_axis: 'label X',
        y_axis: 'label Y'

    m.points.push [   0, 0, 0 ]
    m.points.push [ 100, 1, 0 ]
    m.points.push [ 200, 3, 0 ]
    m.points.push [ 255, 2, 0 ]
    
    c.items.push m
    c.fit 0
    c.draw()
    