# lib gen/Soja.js
# lib gen/ModelEditor.js
# lib gen/ModelEditor.css
# lib gen/DomHelper.js
# lib gen/Color.js
# lib gen/Geometry.js
# lib gen/BrowserState.js
# lib gen/CanvasManager.js
# lib gen/Animation.js
# lib gen/Theme.js
add_cm = ( w, o ) ->
    d = new_dom_element
        parentNode: document.body
        style     : { position: "fixed", top: 0, left: o, width: w, height: 600 }
    
    c = new CanvasManager el: d, want_aspect_ratio: true, padding_ratio: 1.2
    c.cam.threeD.set false
    c.resize w, 600
    
    # Background
    bg = new Background
    bg.gradient.remove_color 1
    c.items.push bg
    
    # BarChart
    m = new BarChart
    m.points.push [   0, 0, 0 ]
    m.points.push [ 100, 1, 0 ]
    m.points.push [ 200, 2, 0 ]
    m.points.push [ 255, 1, 0 ]
    c.items.push m
    
    #     m = new Mesh
    #     s = 800
    #     t = 200
    #     m.add_point [ 0, 0, 0 ]
    #     m.add_point [ t, 0, 0 ]
    #     m.add_point [ t, s, 0 ]
    #     m.add_point [ 0, s, 0 ]
    #     m.lines.push [ 0, 1 ]
    #     m.lines.push [ 1, 2 ]
    #     m.lines.push [ 2, 3 ]
    #     m.lines.push [ 3, 0 ]
    #     c.items.push m
    
    c.fit()
    c.draw()
    
test_Curves = ->    
   add_cm 800, 0
   add_cm 200, 810
   