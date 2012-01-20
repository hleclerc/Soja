class ColorPickerImg extends ModelEditorItem
    constructor: ( params ) ->
        super params
        
        
        @container = new_dom_element
            parentNode: @ed
            className : "ModelEditorColorSelector"
            style     :
                display: "inline-block"
                width  : @ew + "%"
            onclick   : ( evt ) =>
#                 p = new_popup @label or "Color picker", event: evt
#                 p.appendChild @d
        
        _src = ""
            
        if @picker_pos == 'bottom'
            _src = "img/slider-bot-opa.png"
        if @picker_pos == 'top'
            _src = "img/slider-top-opa.png"
            
        if @picker_pos == 'left'
            _src = "img/slider-lef-opa.png"
        if @picker_pos == 'right'
            _src = "img/slider-rig-opa.png"
        
        
        @picture = new_dom_element
            parentNode: @container
            nodeName  : "img"
            src       : _src
            style     :
                position: "relative"
                zIndex : "4"
                color  : "rgba(0,0,0,0)"
                
        if @picker_pos == 'bottom'
            _margin_top = "-12px"
            _width = "10px"
            _height = "11px"
            
        if @picker_pos == 'top'
            _margin_top = "-16px"
            _width = "10px"
            _height = "11px"
            
        if @picker_pos == 'left'
            _margin_top = "-10px"
            _margin_left = "1px"
            _width = "13px"
            _height = "9px"
            
        if @picker_pos == 'right'
            _margin_top = "-10px"
            _margin_left = "4px"
            _width = "13px"
            _height = "9px"
            
        @color = new_dom_element
            parentNode : @container
            style      :
                position: "relative"
                zIndex : "3"
                marginTop: _margin_top
                marginLeft: _margin_left
                width   : _width
                height  : _height
                
        # popup preparation
#         @d = new_dom_element()

            
    onchange: ->
        @color.style.background = @model.to_hex()
