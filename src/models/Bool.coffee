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



# false by default
#
class Bool extends Obj
    constructor: ( data ) ->
        super()

        @_data = false

        # default values
        if data?
            @_set data
    
    # toggle true / false ( 1 / 0 )
    toggle: ->
        @set not @_data

    toBoolean: ->
        @_data

    #
    deep_copy: ->
        new Bool @_data

    # we do not take _set from Obj because we want a conversion if value is not a boolean
    _set: ( value ) ->
        if n instanceof Model
            n = value.toBoolean()
        else if value == "false"
            n = false
        else if value == "true"
            n = true
        else
            n = Boolean value

        if @_data != n
            @_data = n
            return true

        return false
        
    #
    _get_fs_data: ( out ) ->
        FileSystem.set_server_id_if_necessary out, this
        out.mod += "C #{@_server_id} #{ 1 * Boolean( @_data ) } "
        