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
class InterpolatedField extends Model
    constructor: ( name ) ->
        super()
        
        @add_attr
            _data: [] # List of { pos: list of { axe_name: ..., axe_value: ... }, field: ... }

    get_drawing_parameters: ( model ) ->
        if @_data.length
            @_data[ 0 ].field.get_drawing_parameters model

    get_sub_field: ( info ) ->
        # TODO other axes
        for t, n in @_data
            if t.pos[ 0 ].axe_name.equals "time"
                if t.pos[ 0 ].axe_value.get() >= info.time
                    return t.field
        if @_data.length
            return @_data[ @_data.length - 1 ].field
            
    get_val: ( info, i ) ->
        f = @get_sub_field info
        if f?
            f.get_val info, i

    draw: ( info, parameters, additionnal_parameters ) ->
        if parameters?._legend?.auto_fit?.get()
            @actualise_value_legend_all_fields parameters._legend
            
        f = @get_sub_field info
        if f?
            f.draw info, parameters, additionnal_parameters
                
    sub_canvas_items: ( additionnal_parameters ) ->
        if @_data.length
            @_data[ 0 ].field.sub_canvas_items additionnal_parameters
        else
            []
    
    z_index: ->
        if @_data.length
            @_data[ 0 ].field.z_index()
        else
            0
#     sub_canvas_items: ->
#         console.log 'interpolated sub canvas'

    actualise_value_legend_all_fields: ( legend ) ->
        max = -Infinity
        min = Infinity
        for interpo_field in @_data
            field = interpo_field.field
            maxus = field.get_max_data()
            minus = field.get_min_data()
            if minus < min
                min = minus
            if maxus > max
                max = maxus
        legend.min_val.set min
        legend.max_val.set max
