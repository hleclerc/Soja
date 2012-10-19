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
# lib DomHelper.js
# lib BrowserState.js
# lib LayoutManager.js
# lib Animation.js
test_LayoutManager = ->
    # m = new LayoutManagerData panel_id: "main_view"
    m = new LayoutManagerData
        sep_norm: 0
        children: [ {
            panel_id: "main_view"
            strength: 3,
        }, {
            sep_norm: 1
            children: [ {
                panel_id: "tree_view"
                max_size: [ 1e5, 500 ]
                border_s: 6
            }, {
                panel_id: "edit_view"
            } ]
        } ]
    
    l = new LayoutManager document.body, m
    l.disp_top    = 20
    l.border_size = 16
    
    new_dom_element
        parentNode: document.body
        nodeName  : "input"
        type      : "button"
        value     : "Random strengths"
        style     : { position: "fixed", top: 5, right: 5 }
        onclick   : ->
            for i in m.panel_ids()
                p = m.find_item_with_panel_id i
                s = 0.1 + 0.8 * Math.random()
                Animation.set p.strength, s
            
                
                
