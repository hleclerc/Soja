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
        if @model.has_been_directly_modified()
            d = @model.size()
#             console.log d
#             w = if d == 1 then @ew / @model.get().length else @ew
            if @model.get().length
                @el = for i in @model.get()
#                     new_model_editor
#                         el        : @el
#                         model     : i
#                         parent    : @line
#                         item_width: @ew
                        
                    new_dom_element
                        parentNode: @ed
                        nodeName  : "span"
                        style     :
                            display: "inline-block"
                            width  : @ew + "%"
                        txt       : i
                         
                if @model.get().length and @line?
                    @line.onmousedown = =>
                        @get_focus()?.set @model[ 0 ].view_id

# 
ModelEditor.default_types.push ( model ) ->
    ModelEditorItem_TypedArray if model instanceof TypedArray
