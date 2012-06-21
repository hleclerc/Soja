#
class ModelEditorItem_TypedArray extends ModelEditorItem
    constructor: ( params ) ->
        super params
        
        @line = new_dom_element
            parentNode: @ed
            nodeName  : "span"
            style     :
                display: "inline-block"
                width  : @ew + "%"
        
        @blck = new_dom_element
            parentNode: @ed
            nodeName  : "span"
            style     :
                display: "inline-block"
                width  : 0
            
    onchange: ->
        # @color_selector.style.background = @model.to_hex()
#         d = @model.dim()
#         if d >= 2
#             @container.style.width "100%"
#             
#         w = if @dim == 1 then @ew / @model.length else @ew
            

# 
ModelEditor.default_types.push ( model ) ->
    console.log model
    ModelEditorItem_TypedArray if model instanceof TypedArray
