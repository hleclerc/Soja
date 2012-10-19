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



# contains (privately on the server) a path to data on the server
class Path extends Model
    # @file is optionnal. Must be a javascript File object
    constructor: ( @file ) ->
        super()

        size = if @file?
            if @file.fileSize? then @file.fileSize else @file.size
        else
            0
        
        @add_attr
            remaining: size
            to_upload: size

    get_file_info: ( info ) ->
        info.remaining = @remaining
        info.to_upload = @to_upload
        
    _get_fs_data: ( out ) ->
        super out
        # permit to send the data after the server's answer
        if @file? and @_server_id & 3
            FileSystem._files_to_upload[ @_server_id ] = this
