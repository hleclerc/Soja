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



# scalar
class ConstrainedVal extends Model
    constructor: ( value, params = {} ) ->
        super()

        @add_attr
            val : value or 0
            _min: if params.min? then params.min else 0
            _max: if params.max? then params.max else 100
            _div: if params.div? then params.div else 0

    get: ->
        @val.get()

    ratio: ->
        ( @val.get() - @_min.get() ) / @delta()
    
    delta: ->
        @_max.get() - @_min.get()
    
    #
    _set: ( value ) ->
        if value instanceof ConstrainedVal
            return @val._set value.get()
        res = @val.set value
        @_check_val()
        return res

    #
    _check_val: ->
        v = @val .get()
        m = @_min.get()
        n = @_max.get()
        d = @_div.get()
        
        if v < m
            @val.set m
        if v > n
            @val.set n
            
        if d
            s = ( n - m ) / d
            r = m + Math.round( ( @val.get() - m ) / s ) * s
            @val.set r
