#
class ModelEditorItem_Button extends ModelEditorItem
    constructor: ( params ) ->
        super params
        
        @select = new_dom_element
            parentNode: @ed
            nodeName  : "input"
            type      : "button"
            value     : @model.txt()
            onclick   : =>
                @model.toggle()
                
            style:
                width: @ew + "%"
                
        if @model.disabled.equals true
            @select.disabled = "true"


    onchange: ->
        @select.value = @model.txt()
        if @model.disabled.has_been_modified()
            @select.disabled = @model.disabled.get()
#         if @model._state.has_been_modified()
             
#         if @model._num.has_been_modified()
#             @select.value = @model.num.get()
 