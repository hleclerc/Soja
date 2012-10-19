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
class ModelEditorItem_Gradient extends ModelEditorItem
    constructor: ( params ) ->
        super params

            
        @canvas = new_dom_element
            parentNode: @ed
            nodeName  : "canvas"
            className : "ModelEditorGradientSelector"
            style     :
                width  : @ew + "%"
                height : 20 # !!!
            onclick: ( evt ) =>
                if @spec_click?
                    @spec_click evt 
                else if not @forbid_picker
                    p = new_popup @label or "Gradient picker", event : evt
                    p.appendChild @d
                    @gp.build_color_picker()
                         
        if not @forbid_picker
            # popup preparation
            @d = new_dom_element()
            @gp = new ModelEditorItem_GradientPicker
                el    : @d
                model : @model
                parent: this
            
        if @forbid_picker
            add_class @canvas, "predefinedGradient"
        
    onchange: ->
        ctx = @canvas.getContext '2d'
        lineargradient = ctx.createLinearGradient 0, 0, @canvas.width, 0
        left_to_right = 1 #true, false set to 0
        for c in @model.color_stop
            lineargradient.addColorStop left_to_right - c.position.get(), 'rgba(' + c.color.r.get() + ',' + c.color.g.get() + ',' + c.color.b.get() + ',' + c.color.a.get() + ')'
        ctx.fillStyle = lineargradient
        ctx.fillRect 0, 0, @canvas.width, @canvas.height
        
# 
ModelEditorItem.default_types.push ( model ) -> ModelEditorItem_Gradient if model instanceof Gradient
        