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
class TreeItem extends Model
    constructor: ->
        super()

        @add_attr
            _ico       : ""
            _name      : ""
            _children  : []
            _output    : []
            _viewable  : 0 # eye
            _allow_vmod: true # autorise check/uncheck view
            _name_class: ""

    # child must be an instance of TreeItem
    add_child: ( child ) ->
        @_children.push child

    # remove child, by ref or by num
    rem_child: ( child ) ->
        if child instanceof TreeItem
            for num_c in [ 0 ... @_children.length ]
                if @_children[ num_c ] == child
                    @_children.splice num_c, 1
                    return
        else
            @_children.splice child, 1
        
    # child must be an instance of TreeItem
    add_output: ( child ) ->
        @_output.push child

    # remove child, by ref or by num
    rem_output: ( child ) ->
        if child instanceof TreeItem
            for num_c in [ 0 ... @_output.length ]
                if @_output[ num_c ] == child
                    @_output.splice num_c, 1
                    return
        else
            @_output.splice child, 1
        
    draw: ( info ) ->
        if @sub_canvas_items?
            for s in @sub_canvas_items()
                s.draw info
            
    anim_min_max: ->
 
    z_index: ->
        0
        
    to_string: ->
        @_name.get()
        