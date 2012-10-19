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



# dep Color
#
class ModelEditorItem_Color extends ModelEditorItem
    constructor: ( params ) ->
        super params
        
        @container = new_dom_element
            parentNode: @ed
            nodeName  : "span"
            className : "ModelEditorColorSelectorBackground"
        @color_selector = new_dom_element
            parentNode: @container
            nodeName  : "span"
            className : "ModelEditorColorSelector"
            txt       : "."
            style     :
                display: "inline-block"
                color  : "rgba(0,0,0,0)"
                width  : @ew + "%"
            onclick   : ( evt )  =>
                # popup construction
                if not @d?
                    @d = new_dom_element()
                    @item_cp = new ModelEditorItem_ColorPicker
                        el    : @d
                        model : @model
                        parent: this
                p = new_popup @label or "Color picker", event : evt
                p.appendChild @d
                #@item_cp._init_edt() need base
            
    onchange: ->
        @color_selector.style.background = @model.to_hex()

# 
ModelEditorItem.default_types.push ( model ) -> ModelEditorItem_Color if model instanceof Color
