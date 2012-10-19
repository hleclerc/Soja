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
class MoveScheme_2D extends Model
    constructor: ->
        super()
        
        @add_attr
            _O : new Vec_3 [ 0, 0, 0 ]
            _N : new Vec_3 [ 0, 0, 1 ]
    
            
    beg_click: ( pos ) ->
        # nothing to do
        
    move: ( selected_entities, pos, P, D ) ->
        top = Vec_3.dot Vec_3.sub( @_O, P ), @_N
        bot = Vec_3.dot D, @_N
        I = Vec_3.add P, Vec_3.mus( top / bot, D )
        dec = Vec_3.sub I, pos
        for m in selected_entities when m instanceof Point
            m.pos.set Vec_3.add m.pos.get(), dec
            