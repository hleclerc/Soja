#
class ModelEditorItem_Aggregate extends ModelEditorItem
    constructor: ( params ) ->
        super params
        @containers = {}
        
    onchange: ->
        # new editors
        for name in @model.attribute_names when name[ 0 ] != "_"
            if not @containers[ name ]?
                @containers[ name ] = 
                    edit: new_model_editor
                        el    : @ed
                        model : @model[ name ]
                        label : @trans_name( name )
                        parent: this
                    span: if @get_justification() then new_dom_element( parentNode: @ed, nodeName  : "span" ) else undefined
                
        # rm unnecessary ones
        for name, me of @containers
            if name not in @model.attribute_names
                me.edit.destructor()
                delete @containers[ name ]

        # justification
        if @get_justification()
            w = 0
            o = []
            for name in @model.attribute_names when name[ 0 ] != "_"
                info = @containers[ name ]
                if w + info.edit.get_item_width() > 100
                    info.span.style.width = 0
                    for span in o[ 0 ... o.length - 1 ]
                        span.style.display = "inline-block"
                        span.style.width = ( 100 - w ) / ( o.length - 1 ) + "%"
                        # span.style.height = 12
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
        