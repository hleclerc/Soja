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
class ModelEditorItem_Button extends ModelEditorItem
    constructor: ( params ) ->
        super params
        
        @select = new_dom_element
            parentNode: @ed
            nodeName  : "input"
            type      : "button"
            value     : @model.txt()
            onclick   : =>
                @model.toggle()
                
            style:
                width: @ew + "%"
                
        if @model.disabled.equals true
            @select.disabled = "true"


    onchange: ->
        @select.value = @model.txt()
        if @model.disabled.has_been_modified()
            @select.disabled = @model.disabled.get()
#         if @model._state.has_been_modified()
             
#         if @model._num.has_been_modified()
#             @select.value = @model.num.get()
 