class ModelEditorItem_ConstrainedVal extends ModelEditorItem
    constructor: ( params ) ->
        super params

        # input
        @inp = new_model_editor
            el        : @ed
            model     : @model
            parent    : this
            item_width: 0.3 * @ew
            item_type : ModelEditorItem_Input

        @ev?.onmousedown = =>
            @get_focus()?.set @inp.view_id

        # slider
        @div = new_dom_element
            parentNode: @ed
            nodeName  : "span"
            className : "ModelEditorSlider"
            style:
                display    : "inline-block"
                width      : 0.7 * @ew - 0.5 + "%"
                marginLeft : 0.5 + "%"
                zIndex     : 1
            onmousedown: ( evt ) =>
                @get_undo_manager()?.snapshot()
                @snapshot = 1
                
                offset = evt.clientX - get_left( @div ) - @cur.offsetWidth / 2
                twidth = @div.offsetWidth - @cur.offsetWidth
                @model.set @model._min.get() + offset * @model.delta() / twidth
                @off_x = 0
                @_on_mouse_down evt, false
            onmousewheel: ( evt ) =>
                if not @snapshot
                    @snapshot = 1
                    @get_undo_manager()?.snapshot()
                
                if evt.wheelDelta?
                    delta = evt.wheelDelta / 120.0
                    if window.opera
                        delta = - delta
                else if evt.detail
                    delta = - evt.detail / 3.0

                m = 10 * ( 1 + 9 * evt.shiftKey ) * ( 1 + 9 * evt.ctrlKey ) * ( 1 + 9 * evt.altKey )
                
                if @model._div.get() != 0
                    @model.set @model.get() + delta * @model.delta() / @model._div.get()
                else
                    @model.set @model.get() + delta * @model.delta() / m
                
                evt.stopPropagation?()
                evt.preventDefault?()
                return false
        
        @div.addEventListener?( "DOMMouseScroll", @div.onmousewheel, false )
        

        @cur = new_dom_element
            parentNode: @div
            className : "ModelEditorSliderItem"
            style:
                position  : "relative"
            onmousedown: ( evt ) =>
                @_on_mouse_down evt


        @_drag_evt_func = ( evt ) => @_drag_evt evt
        @_drag_end_func = ( evt ) => @_drag_end evt

    onchange: ->
        if @div.offsetWidth and @cur.offsetWidth
            @cur.style.left = 100.0 * ( @div.offsetWidth - @cur.offsetWidth ) * @model.ratio() / @div.offsetWidth + "%"
        else
            # hum...
            @cur.style.left = 100.0 * ( 200 - 11 ) * @model.ratio() / 200 + "%"
                
    _on_mouse_down: ( evt, make_off_x = true ) ->
        @old_x = evt.clientX
        if make_off_x
            @off_x = @old_x - get_left( @cur )
        @snapshot = 0
        
        document.addEventListener "mousemove", @_drag_evt_func, true
        document.addEventListener "mouseup"  , @_drag_end_func, true
        evt.stopPropagation?()
        return false
        
    _drag_evt: ( evt ) =>
        if not @snapshot
            @snapshot = 1
            @get_undo_manager()?.snapshot()

        @new_x = evt.clientX
        if @new_x != @old_x
            offset = @new_x - get_left( @div ) - @off_x
            twidth = @div.offsetWidth - @cur.offsetWidth
            @model.set @model._min.get() + offset * @model.delta() / twidth
            
            @old_x = @new_x
            
        evt.preventDefault?()
                
    _drag_end: ( evt ) =>
        document.detachEvent? "onmousemove", @_drag_evt_func
        document.detachEvent? "onmouseup"  , @_drag_end_func
        document.removeEventListener? "mousemove", @_drag_evt_func, true
        document.removeEventListener? "mouseup"  , @_drag_end_func, true
        
