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



# List of files
# _underlying_fs_type is not needed ()
class Directory extends Lst
    constructor: () ->
        super()

    base_type: ->
        File
    
    find: ( name ) ->
        for f in this
            if f.name.equals name
                return f
        return undefined

    load: ( name, callback ) ->
        f = @find name
        if f
            f.load callback
        else
            callback undefined, "file does not exist"
        
    has: ( name ) ->
        for f in this
            if f.name.equals name
                return true
        return false
    
    add_file: ( name, obj, params = {} ) ->
        o = @find name
        if o?
            return o
        res = new File name, obj, params
        @push res
        return res

    get_file_info: ( info ) ->
        info.icon = "folder"
        
