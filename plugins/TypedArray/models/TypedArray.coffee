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



# Used by TypedArray_...
#
class TypedArray extends Model
    # size can be 
    #  - a number
    #  - a list of number
    constructor: ( size, data ) ->
        super()

        # size
        if not size?
            size = []
        if not size.length
            size = [ size ]
        @_size = size
        
        # data
        if not data?
            B = @base_type()
            data = new B @nb_items()
        @_data = data

    base_type: ->
        # -> to be defined by children

    dim: ->
        @_size.length

    size: ( d ) ->
        if d?
            @_size[ d ]
        else
            @_size
        
    set_val: ( index, value ) ->
        index = @_get_index index
        if @_data[ index ] != value
            @_data[ index ] = value
            @_signal_change()
        
    nb_items: ->
        tot = @_size[ 0 ] or 0
        for i in @_size[ 1 ... ]
            tot *= i
        tot
        
    toString: ->
        m = 1
        res = ""
        l = for s in @_size
            o = m
            m *= s
            o
        for v, i in @_data
            res += v
            for j in [ l.length - 1 .. 0 ]
                if i % l[ j ] == l[ j ] - 1
                    res += [ " ", "\n", "\n\n" ][ j ]
                    break
        return res

    equals: ( obj ) ->
        if obj instanceof TypedArray
            if @_size.length != obj._size.length
                return false
            for v, i in @_size
                if v != obj._size[ i ]
                    return false
            return @_data == obj._data
        return @_data == obj

    get: ( index )->
        if index?
            @_data[ @_get_index index ]
        else
            @_data

    resize: ( new_size ) ->
        tot = 1
        for s in new_size
            tot *= s
            
        B = @base_type()
        n = new B tot
        n.set @_data
        @_data = n
        @_size = new_size
        @_signal_change()
        
            
    _set: ( str ) ->
        if typeof( str ) == "string"
            # TODO optimize
            @_set_state str, {}
            return true
            
        if @_data != value or @_size.length != 1 or @_size[ 0 ] != value.length
            B = @base_type()
            @_data = new B value
            @_size = [ value.length ]
            return true
        return false
        
            
    _get_index: ( index ) ->
        if index.length
            o = 0
            m = 1
            for i in [ 0 ... index.length ]
                o += m * index[ i ]
                m *= @_size[ i ]
            return o
        return index

    _get_fs_data: ( out ) ->
        FileSystem.set_server_id_if_necessary out, this
        out.mod += "C #{@_server_id} #{@_get_state()} "
            
    _get_state: ->
        res = ""
        res += @_size.length
        for s in @_size
            res += "," + s
        for d in @_data
            res += "," + d
        return res

    _set_state: ( str, map ) ->
        l = str.split ","
        s = parseInt l[ 0 ]
        @_size = for v in [ 0 ... s ]
            parseInt l[ v + 1 ]
            
        B = @base_type()
        n = @nb_items()
        @_data = new B n
        for v in [ 0 ... n ]
            @_data[ v ] = parseFloat l[ s + 1 + v ]
            
            