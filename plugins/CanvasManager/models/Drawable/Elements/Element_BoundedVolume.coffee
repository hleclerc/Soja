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
class Element_BoundedVolume extends Element
    constructor: ( boundaries = [] ) ->
        super()
        
        @add_attr
            boundaries: boundaries   # list of { e: element ref, o: orientation }
        
    draw: ( info, mesh, proj, is_a_sub ) ->
            
    update_indices: ( done, n_array ) ->
        for b in @boundaries
            b.e.update_indices? done, n_array

    closest_point_closer_than: ( best, mesh, proj, info, pos ) ->
        undefined

    add_sub_element: ( res ) ->
        for b in @boundaries
            if b.e not in res
                res.push b.e
                