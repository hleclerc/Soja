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



# 
class ImageField extends Drawable
    constructor: ( name, path ) ->
        super()
                
        @add_attr
            name : name         
            src  : ""
            
        @rgba = new Image
        @rgba.onload = =>
            @_signal_change()
            
        @src.bind =>
            if @src.length
                @rgba.src = @src.get()

    get_drawing_parameters: ( model ) ->
        model.add_attr
            drawing_parameters:
                _legend: new Legend( "todo" )
                
        model.drawing_parameters.add_attr
            color_map  : model.drawing_parameters._legend.color_map
    
    get_min_data: ->
        0
        
    get_max_data: ->
        255
        
    
    toString: ->
        @name.get()
        
    draw: ( info ) ->
        if @rgba.height
            Img._draw_persp_rec info, @rgba, 0, 0, [ 0, @rgba.height, 0 ], [ 1, 0, 0 ], [ 0, -1, 0 ], [ 0, 0, 1 ]
            
    z_index: () ->
        return 200
        