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
class Val extends Obj
    constructor: ( data ) ->
        super()

        @_data = 0

        # default values
        if data?
            @_set data
    
    # toggle true / false ( 1 / 0 )
    toggle: ->
        @set not @_data

    #
    toBoolean: ->
        Boolean @_data

    #
    deep_copy: ->
        new Val @_data

    #
    add: ( v ) ->
        if v
            @_data += v
            @_signal_change()
        
    # we do not take _set from Obj because we want a conversion if value is not a number
    _set: ( value ) ->
        # console.log value
        if typeof value == "string"
            if value.slice( 0, 2 ) == "0x"
                n = parseInt value, 16
            else
                n = parseFloat value
                if isNaN n
                    n = parseInt value
                if isNaN n
                    console.log "Don't know how to transform #{value} to a Val"
        else if typeof value == "boolean"
            n = 1 * value
        else if value instanceof Val
            n = value._data
        else # assuming a number
            n = value

        if @_data != n
            @_data = n
            return true

        return false
        