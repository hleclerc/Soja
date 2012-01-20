#
class ModelEditorItem_Input extends ModelEditorItem
    constructor: ( params ) ->
        super params
        
        @input = new_dom_element
            parentNode: @ed
            type      : "text"
            nodeName  : "input"
            style     :
                width: @ew + "%"
            onchange  : =>
                @get_undo_manager()?.snapshot()
                @model.set @input.value

    onchange: ->
        
            
        @input.value = @model.get()
 