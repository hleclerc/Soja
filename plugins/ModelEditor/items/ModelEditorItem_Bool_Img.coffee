#
class ModelEditorItem_Bool_Img extends ModelEditorItem
    constructor: ( params ) ->
        super params
        
        @ed.onclick = =>
            @get_undo_manager()?.snapshot()
            @model.toggle()
        
        @span = new_dom_element
            parentNode: @ed
            nodeName  : "span"
            style     :
                display: "inline-block"
                width  : @ew + "%"

    onchange: ->
        if @model.get()
            add_class @span, "ModelEditorItem_CheckImg_1"
            rem_class @span, "ModelEditorItem_CheckImg_0"
        else
            add_class @span, "ModelEditorItem_CheckImg_0"
            rem_class @span, "ModelEditorItem_CheckImg_1"
        
        if @label?
            if @model.toBoolean()
                add_class @label, "modelEditor_checked"
            else
                rem_class @label, "modelEditor_checked"

    
