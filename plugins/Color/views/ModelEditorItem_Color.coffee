# dep Color
#
class ModelEditorItem_Color extends ModelEditorItem
    constructor: ( params ) ->
        super params
        
        @container = new_dom_element
            parentNode: @ed
            nodeName  : "span"
            className : "ModelEditorColorSelectorBackground"
        @color_selector = new_dom_element
            parentNode: @container
            nodeName  : "span"
            className : "ModelEditorColorSelector"
            txt       : "."
            style     :
                display: "inline-block"
                color  : "rgba(0,0,0,0)"
                width  : @ew + "%"
            onclick   : ( evt )  =>
                # popup construction
                if not @d?
                    @d = new_dom_element()
                    @item_cp = new ModelEditorItem_ColorPicker
                        el    : @d
                        model : @model
                        parent: this
                p = new_popup @label or "Color picker", event : evt
                p.appendChild @d
                #@item_cp._init_edt() need base
            
    onchange: ->
        @color_selector.style.background = @model.to_hex()

# 
ModelEditor.default_types.push ( model ) -> ModelEditorItem_Color if model instanceof Color
