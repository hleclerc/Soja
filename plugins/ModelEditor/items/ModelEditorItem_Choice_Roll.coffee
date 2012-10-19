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



# Rolling view of a choice model
class ModelEditorItem_Choice_Roll extends ModelEditorItem
    constructor: ( params ) ->
        super params
        
        @line_height = 30 # enough to contain the text
        
        @container = new_dom_element
            parentNode: @ed
            nodeName  : "span"
            className : "ModelEditorChoiceRoll"
            onclick   : ( evt ) =>
                @snapshot()
                @model.set ( @model.num.get() + 1 ) % @model._nlst().length
                evt.stopPropagation?()
            style:
                color     : "rgba(0,0,0,0)"
                display   : "inline-block"
                width     : @ew + "%"

        @window = new_dom_element
            parentNode: @container
            className : "ModelEditorChoiceRollWindow"
            txt       : "."
                
        @_cl = []

    onchange: ->
        if @model.lst.has_been_modified() or @_cl.length == 0
            for i in @_cl
                i.parentNode.removeChild i
            @_cl = []
                
            cpt = 0
            for i in @model._nlst()
                @_cl.push new_dom_element
                    parentNode : @window
                    txt        : i.get()
                    value      : cpt
                    style      :
                        position : "absolute"
                        left     : 0
                        right    : 0
                        top      : @line_height * cpt + "px"
                    
                cpt += 1
        
        @window.style.top = - @line_height * @model.num.get() + "px" # this modify element.style and not ModelEditorChoiceRollWindow, so nice transition doesn't apply
 
            