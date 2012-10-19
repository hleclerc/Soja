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
class ModelEditorItem_Choice extends ModelEditorItem
    constructor: ( params ) ->
        super params

        @select = new_dom_element
            parentNode: @ed
            nodeName  : "select"
            onchange  : =>
                @snapshot()
                @model.set @select.value
            style:
                width: @ew + "%"

        @ev?.onmousedown = =>
            @get_focus()?.set @view_id
            
    onchange: ->
        if @model.lst.has_been_modified()
            #             if @model.lst.length == 0
            #                 @ed.style.display = 'none'
            #                 return
            #             else
            #                 @ed.style.display = ''
                
            while @select.firstChild?
                @select.removeChild @select.firstChild

            cpt = 0
            for i in @model._nlst()
                selected = ""
                if i.toString() == @model.item().toString()
                    selected = "selected"
                new_dom_element
                    parentNode : @select
                    nodeName   : "option"
                    selected   : selected
                    txt        : i.toString()
                    value      : cpt
                    
                cpt += 1
            
        if @model.num.has_been_modified()
            @select.value = @model.num.get()
 
        if @get_focus()?.has_been_modified()
            if @get_focus().get() == @view_id
                setTimeout ( => @select.focus() ), 1
            else
                @select.blur()