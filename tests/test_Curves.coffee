# lib gen/Soja.js
# lib gen/ModelEditor.js
# lib gen/ModelEditor.css
# lib gen/DomHelper.js
# lib gen/Color.js
# lib gen/Geometry.js
# lib gen/BrowserState.js
# lib gen/CanvasManager.js
test_Curves = ->
    d = new_dom_element
        parentNode: document.body
        style     : { position: "fixed", top: 0, left: 0, width: 800, height: 600 }

    
    c = new CanvasManager el: d, want_aspect_ratio: true, padding_ratio: 1.2
    c.cam.threeD.set false
    c.resize 800, 600

    # Background
    bg = new Background
    bg.gradient.remove_color 1
    c.items.push bg

    # BarChart
    #     m = new BarChart
    #     for p, i in @img._histo
    #         m.points.push [ i , p, 0 ]
    m = new Mesh
    s = 800
    m.add_point [ 0, 0, 0 ]
    m.add_point [ s, 0, 0 ]
    m.add_point [ s, s, 0 ]
    m.add_point [ 0, s, 0 ]
    m.lines.push [ 0, 1 ]
    m.lines.push [ 1, 2 ]
    m.lines.push [ 2, 3 ]
    m.lines.push [ 3, 0 ]
    c.items.push m

    c.fit()
    c.draw()
    
   