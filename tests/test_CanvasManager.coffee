# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2012 Hugo Leclerc
#
# This file is part of Soda.
#
# Soda is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Soda is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with Soda. If not, see <http://www.gnu.org/licenses/>.



# lib Soda.js
# lib ModelEditor.js
# lib ModelEditor.css
# lib DomHelper.js
# lib Color.js
# lib Geometry.js
# lib BrowserState.js
# lib Theme.js
# lib CanvasManager.js
# lib Animation.js
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
    # m.add_element new Element_Line [ 0, 1 ]
    # m.add_element new Element_Line [ 3, 0 ]
    # m.add_element new Element_Arc  [ 1, 2, 3 ]
    m.add_element new Element_BoundedSurf [
        { o: +1, e: new Element_Line [ 0, 1 ] }
        { o: +1, e: new Element_Arc  [ 1, 2, 3 ] }
        { o: +1, e: new Element_Line [ 3, 0 ] }
        #{ o: -1, e: new Element_Line [ 3, 2 ] }
        #{ o: +1, e: new Element_Line [ 3, 0 ] }
    ]
    m.visualization.display_style.set "Wireframe"
    
    c.items.push m
    
    # IMG
    # c.items.push new Img "http://www.tao-yin.com/acupuncture/img/Soda_totum1.jpg"
    
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
        

   