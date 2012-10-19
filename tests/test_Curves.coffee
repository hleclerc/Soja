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
# lib Color.css
# lib Geometry.js
# lib BrowserState.js
# lib CanvasManager.js
# lib Animation.js
# lib Theme.js


# Params available when you use a graph (taken from Graph.coffee)
# show_line   : boolean which represent if a line linking all points must be drawn or not
# line_color  : choose the color of linking line_color (in html way (hexa or string))
# line_width  : width in pixels of line
# shadow      : boolean which represent if shadow on line must be drawn or not
# show_marker : boolean which represent if marker must be drawn or not
# marker      : shape that mark all value : dot, cross, square or bar ( for bar chart )
# marker_size : indicate size in pixels of marker
# marker_color: choose the color of marker (in html way (hexa or string))
# font_color  : color of font in axis and legend
# font_size   : font size in pixels
# show_grid   : boolean which represent if grid must be drawn or not
# grid_color  : choose the color of grid (in html way (hexa or string))
# x_axis      : label for x axis
# y_axis      : label for y axis
# legend_x_division : number of division on X legend including start and begining
# legend_y_division : number of division on y legend including start and begining

# Warning: dimension of resize must suit the parent Node to avoid pixelisation

test_Curves = ->
        
    d = new_dom_element
        parentNode: document.body
        style     : { position: "fixed", top: 0, left: 0 }
        
    c = new CanvasManager
        el: d
        want_aspect_ratio: true
        padding_ratio: 1.4
        constrain_zoom: 'x'
        auto_fit: true
        
    c.cam.threeD.set false
    c.resize 700, 400

    m = new Graph 
        marker: 'dot',
        marker_color: "#f00"
        line_width  : 3,
        line_color: new Color 75, 150, 175
        marker_size: 10,
        x_axis: 'label X',
        y_axis: 'label Y'
        
        
    m.points.push [   0, 12.04, 0 ]
    m.points.push [ 100, 12.8, 0 ]
    m.points.push [ 200, 12.10, 0 ]
    m.points.push [ 255, 12.09, 0 ]
    
    c.items.push m
    c.fit 0
    c.draw()
    g = new_dom_element
        parentNode: document.body
        style     : { position: "fixed", top: 0, left: 800 }
    editor = new_model_editor el: g, model: m, label: "Simple Graph", item_width: 48
    editor.default_types.push ( model ) -> ModelEditorItem_Bool_Img       if model instanceof Bool
    
    new_model_editor el: g, model: c.cam  , label: "cam"  , item_width: 48
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
        marker_size: 2,
        show_line: false,
        show_grid: false,
        x_axis: 'Day',
        y_axis: 'Rain (mm)'

    m.points.push [   0, 0, 0 ]
    m.points.push [  10, 1.5, 0 ]
    m.points.push [  20, 0.2, 0 ]
    m.points.push [  30, 2.1, 0 ]
    m.points.push [  40, 0.6, 0 ]
    m.points.push [  50, 2, 0 ]
    m.points.push [  60, 0.3, 0 ]
    m.points.push [  70, 1, 0 ]
    m.points.push [  80, 3, 0 ]
    m.points.push [  90, 0.4, 0 ]
    m.points.push [ 100, 1, 0 ]
    m.points.push [ 110, 0.5, 0 ]
    m.points.push [ 120, 0.2, 0 ]
    m.points.push [ 130, 2.6, 0 ]
    m.points.push [ 140, 0.4, 0 ]
    m.points.push [ 150, 2, 0 ]
    m.points.push [ 160, 0.7, 0 ]
    m.points.push [ 170, 1, 0 ]
    m.points.push [ 180, 3, 0 ]
    m.points.push [ 190, 0.4, 0 ]
    m.points.push [ 200, 3, 0 ]
    m.points.push [ 210, 5, 0 ]
    m.points.push [ 220, 2.5, 0 ]
    m.points.push [ 230, 0.9, 0 ]
    m.points.push [ 240, 1.4, 0 ]
    m.points.push [ 250, 2, 0 ]
    
    c.items.push m
    c.fit 0
    c.draw()
    