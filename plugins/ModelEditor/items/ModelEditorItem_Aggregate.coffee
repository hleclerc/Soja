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
