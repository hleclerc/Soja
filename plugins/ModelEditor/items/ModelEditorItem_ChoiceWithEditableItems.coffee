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
class ModelEditorItem_ChoiceWithEditableItems extends ModelEditorItem
    constructor: ( params ) ->
        super params

        # choice
        @choice = new_model_editor
            el        : @ed
            model     : @model
            parent    : this
            item_width: @ew
            item_type : ModelEditorItem_Choice

        @editdiv = new_dom_element
            parentNode: @ed
            nodeName  : "span"
            
        @editors = []
            
    onchange: ->
        if @model.lst.has_been_directly_modified()
            for e in @editors
                e.destructor()

            @editors = for l in @model.lst
                new_model_editor
                    el        : @editdiv
                    model     : l
                    parent    : this
                        
            
        if @model.num.has_been_modified() or @model.lst.has_been_directly_modified()
            for e, i in @editors
                e.ed.style.display = ( if @model.num.get() == i then "block" else "none" )
                

    #     ok_for_label: ->
    #         false
            