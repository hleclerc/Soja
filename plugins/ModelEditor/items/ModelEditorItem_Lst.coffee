#
class ModelEditorItem_Lst extends ModelEditorItem
    constructor: ( params ) ->
        super params

        @lst = []
        @dst = []

    onchange: ->
        if @model.has_been_directly_modified() or @lst.length == 0
            for v in @lst
                v.destructor()
            for v in @dst
                v.parentNode.removeChild v
                
            @dim = ModelEditorItem_Lst._rec_dim @model
            if @model.length < 50
                w = if @dim == 1 then @ew / @model.length else @ew
            
                if @model.length
                    @lst = for i in @model
                        new_model_editor
                            el        : @ed
                            model     : i
                            parent    : this
                            item_width: w
                    @dst = []
                else
                    @lst = []
                    @dst = [
                        new_dom_element
                            parentNode: @ed
                            style     :
                                width: @ew + "%"
                                background: "#123456"
                    ]
                    
                        
                if @lst.length and @ev?
                    @ev.onmousedown = =>
                        @get_focus()?.set @lst[ 0 ].view_id


        @fd = true
 
    ok_for_label: ->
        ModelEditorItem_Lst._rec_dim( @model ) == 1
 
    @_rec_dim: ( model ) ->
        while model.disp_only_in_model_editor?()
            model = model.disp_only_in_model_editor()
        d = model.dim true
            
        if d and model[ 0 ]?
            return d + ModelEditorItem_Lst._rec_dim model[ 0 ]
        return d
        