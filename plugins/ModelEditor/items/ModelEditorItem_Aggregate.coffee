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
class ModelEditorItem_Aggregate extends ModelEditorItem
    constructor: ( params ) ->
        super params
        @containers = {}
        
    onchange: ->
        # rm unnecessary ones
        for model_id, me of @containers
            res = false
            for name in @model._attribute_names when name[ 0 ] != "_"
                val = @model[ name ]
                res |= val.model_id == parseInt model_id
            if not res
                me.edit.destructor()
                delete @containers[ model_id ]

        # new editors
        for name in @model._attribute_names when name[ 0 ] != "_"
            val = @model[ name ]
            if not @containers[ val.model_id ]?
                @containers[ val.model_id ] = 
                    edit: new_model_editor
                        el    : @ed
                        model : @model[ name ]
                        label : @get_display_name( @model, name )
                        parent: this
                        name  : name
                    span: if @get_justification() then new_dom_element( parentNode: @ed, nodeName  : "span" ) else undefined
                
        # justification
        if @get_justification()
            w = 0
            o = []
            for name in @model._attribute_names when name[ 0 ] != "_"
                val = @model[ name ]
                info = @containers[ val.model_id ]
                if w + info.edit.get_item_width() > 100
                    info.span.style.width = 0
                    for span in o[ 0 ... o.length - 1 ]
                        span.style.display = "inline-block"
                        span.style.width = ( 100 - w ) / ( o.length - 1 ) + "%"
                    w = 0
                    o = []
                    
                w += info.edit.get_item_width()
                o.push info.span
            
            if w < 100 and o.length >= 2
                span = o[ o.length - 2 ]
                span.style.display = "inline-block"
                span.style.width = ( 100 - w ) / ( o.length - 1 ) + "%"


    ok_for_label: ->
        false
        
    contains_labels: ->
        true
                
    set_disabled: ( val ) ->
        for model_id, me of @containers
            me.edit.set_disabled val
