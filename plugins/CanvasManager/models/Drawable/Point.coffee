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



class Point extends Drawable
    constructor: ( pos, move_scheme = new MoveScheme_3D ) ->
        super()
        
        @add_attr
            pos: new Vec_3 pos
            
        @_mv = move_scheme

    disp_only_in_model_editor: ->
        @pos
        
    beg_click: ( pos ) ->
        @_mv.beg_click pos
    
    move: ( selected_entities, pos, p_0, d_0 ) ->
        @_mv.move selected_entities, pos, p_0, d_0
    
    z_index: ->
        100
        
    size: ( for_display = false ) ->
        [ 3 ]
        