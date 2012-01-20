#
class ModelEditorItem_List extends ModelEditorItem
    constructor: ( params ) ->
        super params

        @lst = []

    onchange: ->
        if @model.has_been_directly_modified() or @lst.length == 0
            for v in @lst
                v.destructor()
            @dim = ModelEditorItem_List._rec_dim @model
            if @model.length < 50
                w = if @dim == 1 then @ew / @model.length else @ew
            
                @lst = for i in @model
                    new_model_editor
                        el        : @ed
                        model     : i
                        parent    : this
                        item_width: w

        @fd = true
 
    ok_for_label: ->
        ModelEditorItem_List._rec_dim( @model ) == 1
 
    @_rec_dim: ( model ) ->
        while model.disp_only_in_model_editor?()
            model = model.disp_only_in_model_editor()
        d = model.dim()
            
        if d and model[ 0 ]?
            return d + ModelEditorItem_List._rec_dim model[ 0 ]
        return d
        