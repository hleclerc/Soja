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



# generic object with data
class Obj extends Model 
    constructor: ( data ) ->
        super()
        
        if data?
            @_set data

    toString: ->
        @_data?.toString()

    equals: ( obj ) ->
        if obj instanceof Obj
            return @_data == obj._data
        return @_data == obj

    get: ->
        @_data

    _get_fs_data: ( out ) ->
        FileSystem.set_server_id_if_necessary out, this
        out.mod += "C #{@_server_id} #{@toString()} "

    _set: ( value ) ->
        if @_data != value
            @_data = value
            return true
        return false
            
    _get_state: ->
        @_data

    _set_state: ( str, map ) ->
        @set str
        