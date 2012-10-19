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



class Gradient extends Model
    constructor: ( predef ) ->
        super()
        
        
        @add_attr
            color_stop : []
            
        if predef == "b2w"
            @add_color [   0,   0,   0, 255 ], 0
            @add_color [ 255, 255, 255, 255 ], 1
    
    add_color: ( color = [ 0, 0, 0, 255 ], position = 0 ) ->
        @color_stop.push
            color: new Color color[0], color[1], color[2], color[3]
            position: position
            
    remove_color: ( position ) ->
        @color_stop.splice position, 1
        
    get_color_from_pos: ( position ) ->
    
#         for c in @color_stop
#             console.log c.position.get()
# 
#         # First program determine in between which color_stop position is
#         @color_stop.sort ( a, b ) ->
#             return b.position.get() - a.position.get()
# 
#         for c in @color_stop
#             console.log c.position.get()

        
        ind_color_stop = []
        for c, i in @color_stop
            if c.position.get() >= position
                # return first color
                if i == 0
                    return [ @color_stop[ 0 ].color.r.get(), @color_stop[ 0 ].color.g.get(), @color_stop[ 0 ].color.b.get(), @color_stop[ 0 ].color.a.get() ]
                else #normal case
                    ind_color_stop.push i-1
                    ind_color_stop.push i
                break
                
        # return last color
        if ind_color_stop.length == 0
            last_ind = @color_stop.length - 1
            return [ @color_stop[ last_ind ].color.r.get(), @color_stop[ last_ind ].color.g.get(), @color_stop[ last_ind ].color.b.get(), @color_stop[ last_ind ].color.a.get() ]

        # Interpolation between two color_stop depending position
        size_of_interval = Math.abs @color_stop[ ind_color_stop[ 1 ] ].position.get() - @color_stop[ ind_color_stop[ 0 ] ].position.get()
        size_of_new_interval = Math.abs @color_stop[ ind_color_stop[ 0 ] ].position.get() - position
        factor = size_of_interval / size_of_new_interval
        
        col_r = @color_stop[ ind_color_stop[ 0 ] ].color.r.get() - Math.round ( Math.abs( @color_stop[ ind_color_stop[ 1 ] ].color.r.get() - @color_stop[ ind_color_stop[ 0 ] ].color.r.get() ) ) / factor
        col_g = @color_stop[ ind_color_stop[ 0 ] ].color.g.get() - Math.round ( Math.abs( @color_stop[ ind_color_stop[ 1 ] ].color.g.get() - @color_stop[ ind_color_stop[ 0 ] ].color.g.get() ) ) / factor
        col_b = @color_stop[ ind_color_stop[ 0 ] ].color.b.get() - Math.round ( Math.abs( @color_stop[ ind_color_stop[ 1 ] ].color.b.get() - @color_stop[ ind_color_stop[ 0 ] ].color.b.get() ) ) / factor
        col_a = @color_stop[ ind_color_stop[ 0 ] ].color.a.get() - Math.round ( Math.abs( @color_stop[ ind_color_stop[ 1 ] ].color.a.get() - @color_stop[ ind_color_stop[ 0 ] ].color.a.get() ) ) / factor

        return [ col_r, col_g, col_b, col_a ]