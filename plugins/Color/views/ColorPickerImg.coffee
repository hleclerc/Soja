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



class ColorPickerImg extends ModelEditorItem
    constructor: ( params ) ->
        super params
        
        
        @container = new_dom_element
            parentNode: @ed
            className : "ModelEditorColorSelector"
            style     :
                display: "inline-block"
                width  : @ew + "%"
            onclick   : ( evt ) =>
#                 p = new_popup @label or "Color picker", event: evt
#                 p.appendChild @d
        
        _src = ""
            
        if @picker_pos == 'bottom'
            _src = "img/slider-bot-opa.png"
        if @picker_pos == 'top'
            _src = "img/slider-top-opa.png"
            
        if @picker_pos == 'left'
            _src = "img/slider-lef-opa.png"
        if @picker_pos == 'right'
            _src = "img/slider-rig-opa.png"
        
        
        @picture = new_dom_element
            parentNode: @container
            nodeName  : "img"
            src       : _src
            style     :
                position: "relative"
                zIndex : "4"
                color  : "rgba(0,0,0,0)"
                
        if @picker_pos == 'bottom'
            _margin_top = "-12px"
            _width = "10px"
            _height = "11px"
            
        if @picker_pos == 'top'
            _margin_top = "-16px"
            _width = "10px"
            _height = "11px"
            
        if @picker_pos == 'left'
            _margin_top = "-10px"
            _margin_left = "1px"
            _width = "13px"
            _height = "9px"
            
        if @picker_pos == 'right'
            _margin_top = "-10px"
            _margin_left = "4px"
            _width = "13px"
            _height = "9px"
            
        @color = new_dom_element
            parentNode : @container
            style      :
                position: "relative"
                zIndex : "3"
                marginTop: _margin_top
                marginLeft: _margin_left
                width   : _width
                height  : _height
                
        # popup preparation
#         @d = new_dom_element()

            
    onchange: ->
        @color.style.background = @model.to_hex()
