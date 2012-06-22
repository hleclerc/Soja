# View of LayoutManagerData
class LayoutManager extends View
    constructor: ( @el, @model, browser_state = new BrowserState ) ->
        super [ @model, browser_state.window_size ]
        
        # input parameters
        @disp_top    = 0 # in pixel
        @disp_left   = 0 # in pixel
        @disp_right  = 0 # in pixel
        @disp_bottom = 0 # in pixel
        @border_size = 6 # in pixel
        
        #
        @_pan_vs_id = {} # panel instance for a given panel_id
        @_int_edges = [] # border created during previous render for resize

        # borders used to cut
        @_ext_edges  = for i in [ 0 ... 4 ]
            do ( i ) =>
                new_dom_element
                    className  : "LayoutManager_Border"
                    onmousedown: ( evt ) => @_cut_border_mouse_down i % 2, i >= 2, evt
                    style      :
                        position: "absolute"
                        cursor  : "wnes"[ i ] + "-resize"

        # border used for cut / resize preview
        @tmp_border = document.createElement "div"
        @tmp_border.style.position = "absolute"
        @tmp_border.style.opacity  = 0.5

        # window.onresize = => @render()
        @_hidden = false

    onchange: ->
        if not @_hidden
            @render()

    # function that creates a new panel instance. May be redefined to created useful panels
    new_panel_instance: ( data, title ) ->
        res = new LayoutManagerPanelInstance @el, data, title
        
        r = Math.floor( Math.random() * 255 )
        g = Math.floor( Math.random() * 255 )
        b = Math.floor( Math.random() * 255 )
        res.div.style.background = "rgb( " + r + ", " + g + ", " + b + " )"

        return res
    
    #
    render: ->
        b = @border_size
        p_min = [ @disp_left                    + b, @disp_top                       + b ]
        p_max = [ @el.offsetWidth - @disp_right - b, @el.offsetHeight - @disp_bottom - b ]

        @flat = @model.make_info p_min, p_max, b

        # cut borders
        @_ext_edges[ 0 ].style.left   = @disp_left   + 0
        @_ext_edges[ 0 ].style.top    = @disp_top   
        @_ext_edges[ 0 ].style.bottom = @disp_bottom
        @_ext_edges[ 0 ].style.width  = @border_size

        @_ext_edges[ 1 ].style.top    = @disp_top    + 0
        @_ext_edges[ 1 ].style.left   = @disp_left   + @border_size
        @_ext_edges[ 1 ].style.right  = @disp_right  + @border_size
        @_ext_edges[ 1 ].style.height = @border_size

        @_ext_edges[ 2 ].style.right  = @disp_right  + 0
        @_ext_edges[ 2 ].style.top    = @disp_top   
        @_ext_edges[ 2 ].style.bottom = @disp_bottom
        @_ext_edges[ 2 ].style.width  = @border_size

        @_ext_edges[ 3 ].style.bottom = @disp_bottom + 0
        @_ext_edges[ 3 ].style.left   = @disp_left   + @border_size
        @_ext_edges[ 3 ].style.right  = @disp_right  + @border_size
        @_ext_edges[ 3 ].style.height = @border_size

        for e in @_ext_edges
            if e.parentNode != @el
                @el.appendChild e

        # _int_edges
        for b in @_int_edges
            if b.parentNode == @el
                @el.removeChild( b )

        @_int_edges = for p in @flat when p.d_border?
            do ( p ) =>
                new_dom_element
                    parentNode : @el
                    className  : "LayoutManager_Border"
                    onmousedown: ( evt ) => @_int_border_mouse_down( p, evt )
                    style      :
                        position: "absolute"
                        cursor  : if p.d_border then "row-resize" else "col-resize"
                        left    : if p.d_border then p.p_min[ 0 ] else p.p_max[ 0 ]
                        top     : if p.d_border then p.p_max[ 1 ] else p.p_min[ 1 ]
                        width   : if p.d_border then p.p_max[ 0 ] - p.p_min[ 0 ] else p.border_s
                        height  : if p.d_border then p.border_s else p.p_max[ 1 ] - p.p_min[ 1 ]
        
        # terminal panels to be created
        used_pid = {}
        for info in @flat when info.children.length == 0
            used_pid[ info.panel_id ] = true
            if not @_pan_vs_id[ info.panel_id ]?
                @_pan_vs_id[ info.panel_id ] = @new_panel_instance info.data
            @_pan_vs_id[ info.panel_id ].render info
        
        # panels to destroy
        keys = for key, val of @_pan_vs_id when not used_pid[ key ]?
            val.destructor()
            key
        for key in keys
            delete @_pan_vs_id[ key ]


    # remove elements from DOM and set @_hidden to true
    hide: ->
        @_hidden = true
        for key, val of @_pan_vs_id
            val.hide()
        for b in @_int_edges
            if b.parentNode == @el
                @el.removeChild b
        for b in @_ext_edges
            if b.parentNode == @el
                @el.removeChild b

    # remove elements from DOM and set @_hidden to true
    show: ->
        @_hidden = false
        @model._signal_change()

    # display an informative message, with className = "LayoutManager_Message"
    set_message: ( msg ) ->
        if not @message?
            @message = document.createElement "span"
            @message.className = "LayoutManager_Message"
            @message.appendChild document.createTextNode msg
        if @message.parentNode == @el
            @el.removeChild @message
        @el.appendChild @message
        
        @message.firstChild.nodeValue = msg
        
    # suppression of the message displayed by set_message
    del_message: () ->
        if @message? and @message.parentNode == @el
            @el.removeChild @message

    _end_mouse_interact: ->
        @el.onmouseup   = null
        @el.onmouseout  = null
        @el.onmousemove = null
        if @tmp_border? and @tmp_border.parentNode == @el
            @el.removeChild @tmp_border
        @del_message()
        
    _int_border_mouse_down: ( repr, evt ) ->
        evt = window.event if not evt?
        
        # mouse
        @el.onmouseup   = ( evt ) => @_int_border_mouse_up repr, evt
        @el.onmouseout  = ( evt ) => @_int_border_mouse_out repr, evt
        @el.onmousemove = ( evt ) => @_int_border_mouse_move repr, evt
  
        evt.preventDefault?()
        evt.returnValue = false
        return false
    
    _int_border_mouse_up: ( repr, evt ) ->
        @_end_mouse_interact()
        @_use_int_border repr, LayoutManager.abs_evt_pos @el, evt
    
    _int_border_mouse_out: ( repr, evt ) ->
        evt = window.event if not evt?
        
        from = evt.relatedTarget || evt.toElement
        if not from or from.nodeName == "HTML"
            @_end_mouse_interact()
    
    _int_border_mouse_move: ( repr, evt ) ->
        evt = window.event if not evt?
        @_update_int_border repr, LayoutManager.abs_evt_pos @el, evt

    _update_int_border: ( info, p ) ->
        par = info.parent
        d = info.d_border
        
        # destruction ?
        p_0 = par.children[ info.num_in_p + 0 ].p_min[ d ]
        p_1 = par.children[ info.num_in_p + 1 ].p_max[ d ]
        if p[ d ] < p_0 or p[ d ] > p_1
            c_0 = p[ d ] < p_0 and par.children[ info.num_in_p + 0 ].can_be_destroyed()
            c_1 = p[ d ] > p_1 and par.children[ info.num_in_p + 1 ].can_be_destroyed()
            if c_0 or c_1
                if c_0
                    LayoutManager.resize_div @tmp_border, par.children[ info.num_in_p + 0 ].p_min, par.children[ info.num_in_p + 0 ].p_max
                else
                    LayoutManager.resize_div @tmp_border, par.children[ info.num_in_p + 1 ].p_min, par.children[ info.num_in_p + 1 ].p_max
                @tmp_border.style.background = "#000000"
                @set_message "Destruction ?"
            else
                @set_message "This item cannot be destroyed"
            return true
        
        # limits
        ok = true

        # min
        l_0 = p_0 + info.border_s / 2 + par.children[ info.num_in_p + 0 ].min_by d
        l_1 = p_1 - info.border_s / 2 - par.children[ info.num_in_p + 1 ].min_by d
        if p[ d ] < l_0 or p[ d ] > l_1
            if p[ d ] < l_0
                p[ d ] = l_0
            else
                p[ d ] = l_1
            @tmp_border.style.background = "#FF0000"
            @set_message "The minimum size is achieved."
            ok = false
            
        # max
        l_0 = p_0 + info.border_s / 2 + par.children[ info.num_in_p + 0 ].max_by d
        l_1 = p_1 - info.border_s / 2 - par.children[ info.num_in_p + 1 ].max_by d
        if p[ d ] > l_0 or p[ d ] < l_1
            if p[ d ] > l_0
                p[ d ] = l_0
            else
                p[ d ] = l_1
            @tmp_border.style.background = "#FF0000"
            @set_message "The maximum size is achieved."
            ok = false
            
        if ok
            @tmp_border.style.background = "#FFFFFF"
            @del_message()
        
        p_min = [ info.p_min[ 0 ], info.p_min[ 1 ] ]
        p_max = [ info.p_max[ 0 ], info.p_max[ 1 ] ]
        p_min[ d ] = p[ d ] - info.border_s / 2
        p_max[ d ] = p[ d ] + info.border_s / 2
        LayoutManager.resize_div @tmp_border, p_min, p_max
        if @tmp_border.parentNode != @el
            @el.appendChild @tmp_border

    _use_int_border: ( info, p ) ->
        par = info.parent
        d = info.d_border
        
        # destruction ?
        p_0 = par.children[ info.num_in_p + 0 ].p_min[ d ]
        p_1 = par.children[ info.num_in_p + 1 ].p_max[ d ]
        if p[ d ] < p_0 or p[ d ] > p_1
            c_0 = p[ d ] < p_0 and par.children[ info.num_in_p + 0 ].can_be_destroyed()
            c_1 = p[ d ] > p_1 and par.children[ info.num_in_p + 1 ].can_be_destroyed()
            if c_0
                @model.rm_panel par.children[ info.num_in_p + 0 ].panel_id
            if c_1
                @model.rm_panel par.children[ info.num_in_p + 1 ].panel_id
            return true
        
        # limits
        l_0 = p_0 + @border_size / 2 + par.children[ info.num_in_p + 0 ].min_by d
        l_1 = p_1 - @border_size / 2 - par.children[ info.num_in_p + 1 ].min_by d
        p[ d ] = Math.max p[ d ], l_0
        p[ d ] = Math.min p[ d ], l_1
        
        if par.children.length > 2
            console.log "TODO: par.children.length > 2"
            
        @model.find_item_with_panel_id( par.children[ 0 ].panel_id ).strength.set p[ d ] - @border_size / 2 - p_0
        @model.find_item_with_panel_id( par.children[ 1 ].panel_id ).strength.set p_1 - p[ d ] - @border_size / 2


    _cut_border_mouse_down: ( d, s, evt ) ->
        evt = window.event if not evt?
        
        # drag_border
        @_update_cut_border d, s, LayoutManager.abs_evt_pos @el, evt
        
        # mouse
        @el.onmouseup   = ( evt ) => @_cut_border_mouse_up d, s, evt
        @el.onmouseout  = ( evt ) => @_cut_border_mouse_out d, s, evt
        @el.onmousemove = ( evt ) => @_cut_border_mouse_move d, s, evt

        evt.preventDefault?()
        evt.returnValue = false
        return false
    
    _cut_border_mouse_up: ( d, s, evt ) ->
        @_end_mouse_interact()
        
        p = LayoutManager.abs_evt_pos @el, evt
        for info in @flat when info.children.length == 0 
            if info.contains( p )
                if info.p_max[ d ] - info.p_min[ d ] <= info.min_by( d ) - @border_size
                    return false
                di = info.p_max[ d ] - info.p_min[ d ] - @border_size
                di += ( di == 0 )
                @model.mk_split d, s, info.panel_id, ( p[ d ] - info.p_min[ d ] - @border_size / 2.0 ) / di
    
    _cut_border_mouse_out: ( d, s, evt ) ->
        evt = window.event if not evt?
        
        from = evt.relatedTarget || evt.toElement
        if not from or from.nodeName == "HTML"
            @_end_mouse_interact()
    
    _cut_border_mouse_move: ( d, s, evt ) ->
        evt = window.event if not evt?
        @_update_cut_border d, s, LayoutManager.abs_evt_pos @el, evt
    

    _update_cut_border: ( d, s, p ) ->
        # [ p_min, p_max ] = LayoutManager.copy( @container.size_box( p ) )
        for info in @flat when info.children.length == 0 and info.contains p
            # size < 0
            if p[ d ] - info.p_min[ d ] <= @border_size / 2 
                continue
            if info.p_max[ d ] - p[ d ] <= @border_size / 2 
                continue
            #
            p_min = [ info.p_min[ 0 ], info.p_min[ 1 ] ]
            p_max = [ info.p_max[ 0 ], info.p_max[ 1 ] ]
            p_min[ d ] = p[ d ] - @border_size / 2
            p_max[ d ] = p[ d ] + @border_size / 2
            if info.p_max[ d ] - info.p_min[ d ] == info.min_by d
                @tmp_border.style.background = "#FF0000"
                @set_message "The panel size is already minimal for this direction."
            else if ( s == 0 and info.p_max[ d ] - p[ d ] < info.min_by( d ) ) or
                    ( s == 1 and p[ d ] - info.p_min[ d ] < info.min_by( d ) )
                @tmp_border.style.background = "#FF0000"
                @set_message "Dividing here would cause this panel to be under minimal size."
            else
                @tmp_border.style.background = "#FFFFFF"
                @del_message()
            LayoutManager.resize_div @tmp_border, p_min, p_max
            if @tmp_border.parentNode != @el
                @el.appendChild @tmp_border
            return true
            
        # -> not in a panel
        if @tmp_border.parentNode == @el
            @el.removeChild @tmp_border
        return false
        
        
    # utility function to resize a DOM object using limit positions
    @resize_div: ( obj, p_min, p_max ) ->
        obj.style.left   = p_min[ 0 ]
        obj.style.top    = p_min[ 1 ]
        obj.style.width  = p_max[ 0 ] - p_min[ 0 ]
        obj.style.height = p_max[ 1 ] - p_min[ 1 ]

    # position of l / window
    @getLeft: ( l ) -> 
        if l.offsetParent?
            return l.offsetLeft + LayoutManager.getLeft( l.offsetParent )
        return l.offsetLeft

    # position of l / window
    @getTop:  ( l ) -> 
        if l.offsetParent?
            return l.offsetTop  + LayoutManager.getTop(  l.offsetParent )
        return l.offsetTop

    # absolute pos of event evt
    @abs_evt_pos: ( obj, evt ) ->
        return [ evt.clientX - LayoutManager.getLeft( obj ), evt.clientY - LayoutManager.getTop( obj ) ]

