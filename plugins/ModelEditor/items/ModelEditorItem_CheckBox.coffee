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
class ModelEditorItem_CheckBox extends ModelEditorItem
    constructor: ( params ) ->
        super params
        
        @legend_focus = params.parent.legend_focus
        
        # checkbox
        span = new_dom_element
            parentNode: @ed
            nodeName  : "span"
            style     :
                width  : @ew + "%"
                display: "inline-block"
        
        @input = new_dom_element
            parentNode: span
            type      : "checkbox"
            nodeName  : "input"
            onchange  : =>
                @snapshot()
                @model.set @input.checked

        
        if @legend_focus != false
            @ev?.onmousedown = =>
                @get_focus()?.set @view_id
                @model.toggle()
            
    onchange: ->
        if @model.has_been_modified()
            @input.checked = @model.toBoolean()

            if @label?
                if @model.toBoolean()
                    add_class @label, "modelEditor_checked"
                else
                    rem_class @label, "modelEditor_checked"
                    
        if @legend_focus != false
            if @get_focus()?.has_been_modified()
                if @get_focus().get() == @view_id
                    @input.focus()
                else
                    @input.blur()