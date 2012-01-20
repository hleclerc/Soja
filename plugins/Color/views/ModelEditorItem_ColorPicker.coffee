# dep Color
#
class ModelEditorItem_ColorPicker extends ModelEditorItem
    constructor: ( params ) ->
        super params
        
        @sat_size = 200
        
        # base with relative position to use absolute for children
        base = new_dom_element parentNode: @ed, style: { position: "relative" }
        baseLeft = new_dom_element parentNode: base, style: { position: "relative"; display:"inline-block"; }
        @_init_sat baseLeft
        @_init_val baseLeft
        @_init_edt base

        #
        @_old_h = -1
        @_old_s = -1

    onchange: ->
        @new_color_block.style.background = @model.to_hex()
        
        [ h, s, v ] = @model.to_hsv()
            
        #
        @value_cur.style.top = ( 1 - v ) * @sat_size - 5

        #
        if @_old_h != h or @_old_s != s
            @_old_h = h
            @_old_s = s
            
            # cursor
            @sat_lum_cur.style.left = ( @sat_lum.width  - 1 ) * h - 5
            @sat_lum_cur.style.top  = ( @sat_lum.height - 1 ) * ( 1 - s ) - 5

            # val canvas
            ctx = @val_can.getContext '2d'
            [ rb, gb, bb ] = Color.hsv_to_rgb h, s, 1
            [ re, ge, be ] = Color.hsv_to_rgb h, s, 0
            lineargradient = ctx.createLinearGradient 0, 0, 0, @sat_lum.height
            lineargradient.addColorStop 0, "rgb(#{rb},#{gb},#{bb})"
            lineargradient.addColorStop 1, "rgb(#{re},#{ge},#{be})"
            ctx.fillStyle = lineargradient
            ctx.fillRect 0, 0, @sat_lum.width, @sat_lum.height

    _init_sat: ( base ) ->
        _sat_evt_func = ( evt ) =>
            x = evt.clientX - get_left( @sat_lum )
            y = evt.clientY - get_top(  @sat_lum )
            [ h, s, v ] = @model.to_hsv()
            h = x / ( @sat_lum.width - 1.0 )
            s = 1 - y / ( @sat_lum.height - 1.0 )
            h = Math.max( 0.0, Math.min( 1.0, h ) )
            s = Math.max( 0.0, Math.min( 1.0, s ) )
            [ r, g, b ] = Color.hsv_to_rgb h, s, v
            @model.r.set r
            @model.g.set g
            @model.b.set b
            
            evt.preventDefault?()
                    
        _sat_end_func = ( evt ) ->
            document.detachEvent? "onmousemove", _sat_evt_func
            document.detachEvent? "onmouseup"  , _sat_end_func
            document.removeEventListener? "mousemove", _sat_evt_func, true
            document.removeEventListener? "mouseup"  , _sat_end_func, true

        @sat_lum = new_dom_element
            parentNode  : base
            nodeName    : "canvas"
            width       : @sat_size
            height      : @sat_size
            onmousedown : ( evt ) =>
                document.addEventListener "mousemove", _sat_evt_func, true
                document.addEventListener "mouseup"  , _sat_end_func, true
                _sat_evt_func evt
                
        @sat_lum_cur = new_dom_element
            parentNode: base
            className : "ColorPickerSatLumSelect"
            style     :
                position: "absolute"
                
        # canvas content
        ctx = @sat_lum.getContext '2d'
        for x in [ 0 ... @sat_lum.width ]
            h = x / ( @sat_lum.width - 1.0 )
            [ rb, gb, bb ] = Color.hsv_to_rgb h, 1, 1
            [ re, ge, be ] = Color.hsv_to_rgb h, 0, 1
            lineargradient = ctx.createLinearGradient 0, 0, 0, @sat_lum.height
            lineargradient.addColorStop 0, "rgb(#{rb},#{gb},#{bb})"
            lineargradient.addColorStop 1, "rgb(#{re},#{ge},#{be})"
            ctx.fillStyle = lineargradient
            ctx.fillRect x, 0, x, @sat_lum.height
                
    #                
    _init_val: ( base ) ->
        _val_evt_func = ( evt ) =>
            y = evt.clientY - get_top(  @sat_lum )
            [ h, s, v ] = @model.to_hsv()
            v = 1 - y / ( @sat_lum.height - 1.0 )
            v = Math.max( 0.0, Math.min( 1.0, v ) )
            [ r, g, b ] = Color.hsv_to_rgb h, s, v
            @model.r.set r
            @model.g.set g
            @model.b.set b
            evt.preventDefault?()
                    
        _val_end_func = ( evt ) ->
            document.detachEvent? "onmousemove", _val_evt_func
            document.detachEvent? "onmouseup"  , _val_end_func
            document.removeEventListener? "mousemove", _val_evt_func, true
            document.removeEventListener? "mouseup"  , _val_end_func, true

        @val_can = new_dom_element
            parentNode : base
            nodeName   : "canvas"
            width      : 23
            height     : @sat_size
            onmousedown : ( evt ) =>
                document.addEventListener "mousemove", _val_evt_func, true
                document.addEventListener "mouseup"  , _val_end_func, true
                _val_evt_func evt
            style      :
                marginLeft: 10
            
        @value_cur = new_dom_element
            parentNode: base
            className : "ColorPickerChromiSelect"
            style     :
                position: "absolute"
                left    : 204

    #
    _init_edt: ( base ) ->
        ed = new_dom_element
            parentNode: base
            nodeName  : "span"
            style     :
                marginLeft: 10
                display    : "inline-block"
                width      : 200

        @old_color_block = new_dom_element
            parentNode: ed
            nodeName  : "span"
            style     :
                display     : "inline-block"
                marginBottom: 15
                width       : "49%"
                height      : 100
                background  : @model.to_hex()

        @new_color_block = new_dom_element
            parentNode: ed
            nodeName  : "span"
            style     :
                display     : "inline-block"
                marginLeft  : "2%"
                marginBottom: 15
                width       : "49%"
                height      : 100
        
                
                
        new_model_editor el: ed, model: @model.r, label: "R", label_ratio: 0.1
        new_model_editor el: ed, model: @model.g, label: "G", label_ratio: 0.1
        new_model_editor el: ed, model: @model.b, label: "B", label_ratio: 0.1
        new_model_editor el: ed, model: @model.a, label: "A", label_ratio: 0.1

        new_dom_element
            parentNode: ed
            style     :
                display    : "inline-block"
                width      : 1
                height     : 1
