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
            onfocus   : =>
                @get_focus()?.set @view_id

        @ev?.onmousedown = =>
            @get_focus()?.set @view_id
                
    onchange: ->
        if @model.has_been_modified()
            @input.value = @model.get()
            
        if @get_focus()?.has_been_modified()
            if @get_focus().get() == @view_id
                setTimeout ( => @input.focus() ), 1
            else
                @input.blur()
            