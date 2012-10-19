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



# contains an id of a model on the server
#
#
class Ptr extends Model
    # model may be a number (the pointer)
    constructor: ( model ) ->
        super()
        @data = {}
        @_set model
        
    load: ( callback ) ->
        if @data.model?
            callback @data.model, false
        else
            FileSystem.get_inst()?.load_ptr @data.value, callback
            
        
    _get_fs_data: ( out ) ->
        FileSystem.set_server_id_if_necessary out, this
        if @data.model?
            FileSystem.set_server_id_if_necessary out, @data.model
            out.mod += "C #{@_server_id} #{@data.model._server_id} "
            #
            @data.value = @data.model._server_id
            if @data.model._server_id & 3
                FileSystem._ptr_to_update[ @data.model._server_id ] = this
        else
            out.mod += "C #{@_server_id} #{@data.value} "

    _set: ( model ) ->
        if typeof model == "number"
            res = @data.value != model
            @data =
                value: model
            return res
            
        if model instanceof Model
            res = @data.value != model._server_id
            @data =
                model: model
                value: model._server_id
            return res
                
        return false
            
    _get_state: ->
        @_data

    _set_state: ( str, map ) ->
        @set str

