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



# String
class Str extends Obj
    constructor: ( data ) ->
        super()
        
        # default value
        @_data = ""
        @length = 0

        # init if possible
        if data?
            @_set data

    # toggle presence of str in this
    toggle: ( str, space = " " ) ->
        l = @_data.split space
        i = l.indexOf str
        if i < 0
            l.push str
        else
            l.splice i, 1
        @set l.join " "

    # true if str is contained in this
    contains: ( str ) ->
        @_data.indexOf( str ) >= 0

    #
    equals: ( str ) ->
        @_data == str.toString()
        
    #
    ends_with: ( str ) ->
        l = @_data.match( str + "$" )
        l?.length and l[ 0 ] == str
        
    #
    deep_copy: ->
        new Str @_data + ""

    #
    _get_fs_data: ( out ) ->
        FileSystem.set_server_id_if_necessary out, this
        out.mod += "C #{@_server_id} #{encodeURI @_data} "

    #
    _set: ( value ) ->
        if not value?
            return @_set ""
        n = value.toString()
        if @_data != n
            @_data = n
            @length = @_data.length
            return true
        return false

    #
    _get_state: ->
        encodeURI @_data

    _set_state: ( str, map ) ->
        @set decodeURIComponent str

    
    