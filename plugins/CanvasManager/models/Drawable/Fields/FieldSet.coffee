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
class FieldSet extends Drawable
    constructor: ->
        super()
        
        @add_attr
            color_by   : new Choice # list of NamedParametrizedDrawable containing fields
            warp_by    : new Choice # list of NamedParametrizedDrawable containing nD fields
            warp_factor: 0 # 
            # gradient  : new Gradient
        
    get_model_editor_parameters: ( res ) ->
        res.model_editor[ "color_by" ] = ModelEditorItem_ChoiceWithEditableItems
        # res.model_editor[ "warp_by" ] = ModelEditorItem_ChoiceWithEditableItems
            
    draw: ( info ) ->
        f = @color_by.item()
        if f?
            f.draw info,
                warp_by    : if @warp_by.item()? then @warp_by.item().data else undefined
                warp_factor: @warp_factor.get()
                # gradient   : @gradient
                
    sub_canvas_items: ( additionnal_parameters ) ->
        f = @color_by.item()
        if f?
            f.sub_canvas_items additionnal_parameters
        else
            []

    z_index: ->
        150
        