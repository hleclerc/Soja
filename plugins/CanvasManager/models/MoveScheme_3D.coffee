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
class MoveScheme_3D extends Model
    constructor: ->
        super()
        
        @add_attr
            _req_pos : new Vec_3
            _req_dir : new Vec_3
            _old_pos : new Vec_3
            _old_dir : new Vec_3
  
        @cos_for_move_req_old_dir = 0.7
        @_beg_click = false
  
    beg_click: ( pos )->
        @_beg_click = true
            
    move: ( selected_entities, pos, p_0, d_0 ) ->
        if @_beg_click
            @_beg_click = false

            # if the previous move has left a "very" different direction, 
            d_1 = @_old_dir.get()
            dok = d_1[ 0 ] or d_1[ 1 ] or d_1[ 2 ]
            if dok and Math.abs( Vec_3.dot d_0, d_1 ) < @cos_for_move_req_old_dir
                @_req_pos.set @_old_pos
                @_req_dir.set @_old_dir
            
            
        
        # by default, projection of the point to line p_0, d_0
        l_0 = Vec_3.dot( Vec_3.sub( pos.get(), p_0 ), d_0 )
        
        # if old dir and pos from previous move, use point from ( p_0, d_0 ), closest to line ( p_1, d_1 )
        p_1 = @_req_pos.get()
        d_1 = @_req_dir.get()
        if d_1[ 0 ] or d_1[ 1 ] or d_1[ 2 ]
            c_00 = d_0[ 0 ] * d_0[ 0 ] + d_0[ 1 ] * d_0[ 1 ] + d_0[ 2 ] * d_0[ 2 ]
            c_01 = d_0[ 0 ] * d_1[ 0 ] + d_0[ 1 ] * d_1[ 1 ] + d_0[ 2 ] * d_1[ 2 ]
            c_11 = d_1[ 0 ] * d_1[ 0 ] + d_1[ 1 ] * d_1[ 1 ] + d_1[ 2 ] * d_1[ 2 ]
            dete = c_00 * c_11 - c_01 * c_01
            
            ve_0 = d_0[ 0 ] * ( p_0[ 0 ] - p_1[ 0 ] ) + d_0[ 1 ] * ( p_0[ 1 ] - p_1[ 1 ] ) + d_0[ 2 ] * ( p_0[ 2 ] - p_1[ 2 ] )
            ve_1 = d_1[ 0 ] * ( p_0[ 0 ] - p_1[ 0 ] ) + d_1[ 1 ] * ( p_0[ 1 ] - p_1[ 1 ] ) + d_1[ 2 ] * ( p_0[ 2 ] - p_1[ 2 ] )
            
            l_0 = ( c_01 * ve_1 - c_11 * ve_0 ) / dete
            
        del = for d in [ 0 .. 2 ]
            p_0[ d ] + d_0[ d ] * l_0 - pos[ d ].get() 
            
        for m in selected_entities when m instanceof Point
            for d in [ 0 .. 2 ]
                m.pos[ d ].set m.pos[ d ].get() + del[ d ]
            
        @_old_pos.set p_0
        @_old_dir.set d_0
