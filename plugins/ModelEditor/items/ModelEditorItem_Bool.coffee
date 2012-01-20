#
class ModelEditorItem_CheckBox extends ModelEditorItem
    constructor: ( params ) ->
        super params
        
        # checkbox
        span = new_dom_element
            parentNode: @ed
            nodeName  : "span"
            style     :
                width  : @ew + "%"
                display: "inline-block"
        
        @input = new_dom_element
            parentNode: span
            type      : "checkbox"
            nodeName  : "input"
            onchange  : =>
                @get_undo_manager()?.snapshot()
                @model.set @input.checked
        
    onchange: ->
        @input.checked = @model.toBoolean()

        if @label?
            if @model.toBoolean()
                add_class @label, "modelEditor_checked"
            else
                rem_class @label, "modelEditor_checked"

    