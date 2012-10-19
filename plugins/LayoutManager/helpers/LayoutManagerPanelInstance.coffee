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



# example
class LayoutManagerPanelInstance
    constructor: ( @el, data, title = "", elem_kind = "div" ) ->
        @div = document.createElement elem_kind
        @div.style.position = "absolute"
        @title = title
        
    destructor: ->
        @hide()

    render: ( info, offset = 0 ) ->
        @el.appendChild @div
        
        p_min = info.p_min
        p_max = info.p_max
        
        @div.style.left   = p_min[ 0 ] - offset
        @div.style.top    = p_min[ 1 ] - offset
        @div.style.width  = p_max[ 0 ] - p_min[ 0 ]
        @div.style.height = p_max[ 1 ] - p_min[ 1 ]
        
        
        if @title != "" and not @title_elem?
            @title_elem = new_dom_element
                nodeName  : "div"
                className : "Title"
                parentNode: @div
                txt       : @title
        
    hide: ->
        if @title_elem?.parentNode == @div
            @div.removeChild @title_elem
        if @div.parentNode == @el
            @el.removeChild @div
