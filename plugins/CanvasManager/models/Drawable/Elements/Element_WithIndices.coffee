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



# straight line strip
class Element_WithIndices extends Element
    constructor: ( indices = [] ) ->
        super()
        
        @add_attr
            indices: indices # point numbers
            
    points_inside: ( tab_ind ) ->
        for i in tab_ind
            for a in @indices
                if a.equals i
                    return true
        return false
        
    get_point_numbers: ->
        @indices.get()
            
    update_indices: ( done, n_array ) ->
        if not done[ @model_id ]?
            done[ @model_id ] = true
            for v in @indices
                v.set n_array[ v.get() ]
