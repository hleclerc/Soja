# dep ModelEditorItem.coffee

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
                @snapshot()
                @model.set @input.value
            onfocus   : =>
                @focus?.set @view_id

        @ev?.onmousedown = =>
            @focus?.set @view_id
                
    onchange: ->
        console.log new Date
        if @model.has_been_modified
            @input.value = @model.get()
        
        if @focus?.has_been_modified
            if @focus.get() == @view_id
                setTimeout ( => @input.focus() ), 1
            else
                @input.blur()
                
    set_disabled: ( val ) ->
        @input.disabled = val
        