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
class ModelEditorItem_Bool_Img extends ModelEditorItem
    constructor: ( params ) ->
        super params
        
        @ed.onclick = =>
            @snapshot()
            @model.toggle()
        
        @span = new_dom_element
            parentNode: @ed
            nodeName  : "span"
            style     :
                display: "inline-block"
                width  : @ew + "%"

    onchange: ->
        if @model.get()
            add_class @span, "ModelEditorItem_CheckImg_1"
            rem_class @span, "ModelEditorItem_CheckImg_0"
        else
            add_class @span, "ModelEditorItem_CheckImg_0"
            rem_class @span, "ModelEditorItem_CheckImg_1"
        
        if @label?
            if @model.toBoolean()
                add_class @label, "modelEditor_checked"
            else
                rem_class @label, "modelEditor_checked"

    
