class ModelEditorItem_ConstOrNotModel extends ModelEditorItem
    constructor: ( params ) ->
        super params

        # input
        @inp = new_model_editor
            el        : @ed
            model     : @model.model
            parent    : this
            item_width: @ew


    onchange: ->
        if @model.bool.has_been_modified()
            @inp.set_disabled not @model.bool.get()
        
    display_label: ->
        false
