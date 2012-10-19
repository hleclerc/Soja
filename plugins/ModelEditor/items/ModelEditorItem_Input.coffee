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
class ModelEditorItem_Input extends ModelEditorItem
    constructor: ( params ) ->
        super params
        
        @input = new_dom_element
            parentNode: @ed
            type      : "text"
            nodeName  : "input"
            style     :
                width: @ew + "%"
            onchange  : =>
                @snapshot()
                @model.set @input.value
            onfocus   : =>
                @get_focus()?.set @view_id

        @ev?.onmousedown = =>
            @get_focus()?.set @view_id
                
    onchange: ->
        if @model.has_been_modified()
            @input.value = @model.get()
            
        if @get_focus()?.has_been_modified()
            if @get_focus().get() == @view_id
                setTimeout ( => @input.focus() ), 1
            else
                @input.blur()
                
    set_disabled: ( val ) ->
        @input.disabled = val
        