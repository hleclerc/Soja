#
class CanvasManager extends View
    # mandatory params :
    #  - el; laceholder
    #  - items:
    # optionnal params :
    #  - undo_manager
    #  - allow_gl
    #  - want_aspect_ratio
    #  - constrain_zoom
    constructor: ( params ) ->
        # use params
        for key, val of params
            @[ key ] = val

        # default values
        dv = ( field, fun ) =>
            if not this[ field ]?
                this[ field ] = fun()

        dv "items"                , -> new Lst
        dv "cam"                  , => new Cam @want_aspect_ratio
        dv "allow_gl"             , -> false
        dv "theme"                , -> new Theme 'original'
        dv "time"                 , -> new ConstrainedVal( 0, { min: 0, max: -1, div: 0 } )
        dv "padding_ratio"        , -> 1.5
        dv "constrain_zoom"       , -> false
        dv "auto_fit"             , -> false
            
        super [ @items, @cam, @time ]

        #
        @canvas = new_dom_element
            style     : { width: "100%" }
            nodeName  : "canvas"
            parentNode: @el

        # events
        @canvas.onmousewheel = ( evt ) => @_mouse_wheel evt
        @canvas.onmousedown  = ( evt ) => @_mouse_down evt
        @canvas.onmousemove  = ( evt ) => @_mouse_move evt
        @canvas.onmouseout   = ( evt ) => @_mouse_out evt
        @canvas.ondblclick   = ( evt ) => @_dbl_click evt
        @canvas.onmouseup    = ( evt ) => @_mouse_up evt
        @canvas.addEventListener? "DOMMouseScroll", @canvas.onmousewheel, false

        # drawing context
        @_init_ctx @allow_gl
        @x_min = [ 0, 0, 0 ]
        @x_max = [ 1, 1, 1 ]

        #
        @click_fun    = [] # called if mouse down and up without move
        @dblclick_fun = []

    onchange: ->
        if @need_to_redraw()
            @draw()
            
    need_to_redraw: ->
        return true if @items.has_been_directly_modified?()
        return true if @cam.has_been_modified?()
        return true if @theme.has_been_modified?()
        return true if @time.has_been_modified?()

        # if list of active_items has changed (not regarding the objects themselves)
        str_sel = ""
        for s in @active_items()
            if not s.has_nothing_to_draw?()
                str_sel += " " + s.model_id
        if @_old_str_sel != str_sel
            @_old_str_sel = str_sel
            return true
            
        # all objects and sub objects
        flat = []
        for item in @items
            CanvasManager._get_flat_list flat, item
        for f in flat
            if f.has_been_modified?()
                return true
                
        return false
        
    #
    bounding_box: ->
        if @_bounding_box?
            return @_bounding_box
            
        get_min_max = ( item, x_min, x_max ) ->
            item.update_min_max? x_min, x_max
            if item.sub_canvas_items?
                for sub_item in item.sub_canvas_items()
                    get_min_max sub_item, x_min, x_max
                    
        x_min = [ +1e40, +1e40, +1e40 ]
        x_max = [ -1e40, -1e40, -1e40 ]
        for item in @items
            get_min_max item, x_min, x_max
        if x_min[ 0 ] == +1e40
            return [ [ -1, -1, -1 ], [ 1, 1, 1 ] ]
        @_bounding_box = [ x_min, x_max ]
        return @_bounding_box
        
    # 
    fit: ( anim = 1 ) ->
        b = @bounding_box()

        O = [
            0.5 * ( b[ 1 ][ 0 ] + b[ 0 ][ 0 ] ),
            0.5 * ( b[ 1 ][ 1 ] + b[ 0 ][ 1 ] ), 
            0.5 * ( b[ 1 ][ 2 ] + b[ 0 ][ 2 ] )
        ]
        
        d = @padding_ratio * Math.max(
            ( b[ 1 ][ 0 ] - b[ 0 ][ 0 ] ),
            ( b[ 1 ][ 1 ] - b[ 0 ][ 1 ] ),
            ( b[ 1 ][ 2 ] - b[ 0 ][ 2 ] )
        )
        d = 1 if d == 0
        
        if @cam.r?
            w = @canvas.width
            h = @canvas.height
            
            # assuming a 2D cam
            dx = ( b[ 1 ][ 0 ] - b[ 0 ][ 0 ] )
            dy = ( b[ 1 ][ 1 ] - b[ 0 ][ 1 ] )
            dy = 1 if dy == 0
            ip = 1 / @padding_ratio
            
            if w > h
                rx = ( ip * w ) / ( w - h * ( 1 - ip ) )
                @aset @cam.r, rx * ( h * dx ) / ( w * dy ), anim
                d = dy * @padding_ratio
            else
                ry = ( h - w * ( 1 - ip ) ) / ( ip * h )
                res = ry * ( h * dx ) / ( w * dy )
                @aset @cam.r, res, anim
                d = dx / res * @padding_ratio
    
        @aset @cam.O, O, anim
        @aset @cam.d, d, anim
        @aset @cam.C, @cam.O, anim
    
    # animed set (according to parameters defined in @theme)
    aset: ( model, value, anim = 1 ) ->
        Animation.set model, value, anim * @theme.anim_delay.get()
        
    # 
    top: ->
        @aset @cam.X, [ 1, 0, 0 ]
        @aset @cam.Y, [ 0, 0, 1 ]
    # 
    bottom: ->
        @aset @cam.X, [ 1, 0, 0 ]
        @aset @cam.Y, [ 0, 0,-1 ]
    
    # 
    right: ->
        @aset @cam.X, [ 0, 0, 1 ]
        @aset @cam.Y, [ 0, 1, 0 ]
    
    #
    left: ->
        @aset @cam.X, [ 0, 0,-1 ]
        @aset @cam.Y, [ 0, 1, 0 ]
    
    #
    origin: ->
        @aset @cam.X, [ 1, 0, 0 ]
        @aset @cam.Y, [ 0, 1, 0 ]

    # redraw all the scene
    draw: ->
        @_flat = []
        for item in @items
            CanvasManager._get_flat_list @_flat, item
        
        #
        has_a_background       = false
        has_a_changed_drawable = false
        for f in @_flat
            has_a_background |= f.draws_a_background?()
            has_a_changed_drawable |= f.has_been_modified?()

        if has_a_changed_drawable
            delete @_bounding_box

        #
        if not has_a_background
            @ctx.clearRect 0, 0, @canvas.width, @canvas.height
        
        if @auto_fit and has_a_changed_drawable
            if @first_fit?
                @fit 1
            else
                @first_fit = true
                @fit 0
        
        #
        @_mk_cam_info()
        
        #sort object depending on z_index (a greater z_index is in front of an element with a lower z_index)
        @_flat.sort ( a, b ) -> a.z_index() - b.z_index()
        for item in @_flat
            item.draw @cam_info

    resize: ( w, h ) ->
        @canvas.width  = w
        @canvas.height = h
        
    # return a list of items which can take events
    # BEWARE: may be surdefined (as e.g. in CanvasManagerPanelInstance)
    active_items: ->
        @items
        
    active_items_rec: ( l = @active_items() ) ->
        res = []
        for item in l
            res.push item
            if item.sub_canvas_items?
                for sub_item in @active_items_rec item.sub_canvas_items()
                    res.push sub_item
        res
        
    # 
    _catch_evt: ( evt ) ->
        evt.preventDefault?()
        evt.returnValue = false
        false
            
    _dbl_click: ( evt ) ->
        evt = window.event if not evt?
                
        @mouse_x = evt.clientX - get_left( @canvas )
        @mouse_y = evt.clientY - get_top ( @canvas )
        
        for item in @active_items_rec()
            if item.on_dbl_click? this, evt, [ @mouse_x, @mouse_y ], @mouse_b
                return @_catch_evt evt
                
        for fun in @dblclick_fun
            if fun this, evt, [ @mouse_x, @mouse_y ], @mouse_b
                return @_catch_evt evt
                
        @_catch_evt evt

    _mouse_down: ( evt ) ->
        @mouse_has_moved_since_mouse_down = false
        evt = window.event if not evt?

        @mouse_b = if evt.which?
            if evt.which < 2
                "LEFT"
            else if evt.which == 2 
                "MIDDLE"
            else
                "RIGHT"
        else
            if evt.button < 2
                "LEFT"
            else if evt.button == 4 
                "MIDDLE"
            else
                "RIGHT"
                
        @mouse_x = evt.clientX - get_left( @canvas )
        @mouse_y = evt.clientY - get_top ( @canvas )
        
        # click_fun from selected items
        for item in @active_items_rec()
            if item.on_mouse_down? this, evt, [ @mouse_x, @mouse_y ], @mouse_b
                return @_catch_evt evt

        # else, default click functions
        for fun in @click_fun
            if fun this, evt, [ @mouse_x, @mouse_y ], @mouse_b
                return @_catch_evt evt
            
        # default behavior
        if @mouse_b == "RIGHT"
            @canvas.oncontextmenu = => return false
            evt.stopPropagation()
            evt.cancelBubble = true
            # ... rien ne marche sous chrome sauf document.oncontextmenu = => return false 
            document.oncontextmenu = => return false
            
        @_catch_evt evt        
    
    _mouse_up: ( evt ) ->
        @context_menu? evt, @mouse_b == "RIGHT" and not @mouse_has_moved_since_mouse_down            
        delete @mouse_b
        delete @clk_x
        delete @clk_y

    _mouse_out: ( evt ) ->
        delete @mouse_b
        delete @clk_x
        delete @clk_y
            
    # zoom sur l'objet avec la mollette
    _mouse_wheel: ( evt ) ->
        evt = window.event if not evt?
        @mouse_x = evt.clientX - get_left( @canvas )
        @mouse_y = evt.clientY - get_top ( @canvas )

        # browser compatibility -> stolen from http://unixpapa.com/js/mouse.html
        delta = 0
        if evt.wheelDelta?
            delta = evt.wheelDelta / 120.0
            if window.opera
                delta = - delta
        else if evt.detail
            delta = - evt.detail / 3.0

        # 
        for item in @active_items_rec()
            if item.on_mouse_wheel? this, evt, [ @mouse_x, @mouse_y ], @mouse_b, delta
                return @_catch_evt evt

        # do the zoom
        c = Math.pow 1.2, delta
        cx = if evt.shiftKey or @constrain_zoom == "y" then 1 else c
        cy = if evt.altKey   or @constrain_zoom == "x" then 1 else c
        @cam.zoom @mouse_x, @mouse_y, [ cx, cy ], @canvas.width, @canvas.height
        
        @_catch_evt evt        
            
    _mouse_move: ( evt ) ->
        old_x = @mouse_x
        old_y = @mouse_y
    
        evt = window.event if not evt?
        @mouse_has_moved_since_mouse_down = true
        @rea_x = evt.clientX - get_left( @canvas )
        @rea_y = evt.clientY - get_top ( @canvas )
        if evt.ctrlKey and @mouse_b
            if not @clk_x?
                @clk_x = @rea_x
                @clk_y = @rea_y
            @mouse_x = @clk_x + ( @rea_x - @clk_x ) / 10
            @mouse_y = @clk_y + ( @rea_y - @clk_y ) / 10
        else
            @mouse_x = @rea_x
            @mouse_y = @rea_y
        
        # click_fun from selected items
        for item in @active_items_rec()
            if item.on_mouse_move? this, evt, [ @mouse_x, @mouse_y ], @mouse_b, [ old_x, old_y ]
                return @_catch_evt evt

        # default behavior (cam change)
        w   = @canvas.width
        h   = @canvas.height
        mwh = Math.min w, h
        
        # rotate / z_screen
        if @mouse_b == "LEFT" and evt.shiftKey
            a = Math.atan2( @mouse_y - 0.5 * h, @mouse_x - 0.5 * w ) - Math.atan2( old_y - 0.5 * h, old_x - 0.5 * w )
            @cam.rotate 0.0, 0.0, a
            return @_catch_evt evt        
            
        # pan
        if @mouse_b == "MIDDLE" or @mouse_b == "LEFT" and evt.ctrlKey
            x = @constrain_zoom != "y"
            y = @constrain_zoom != "x"
            @cam.pan ( @mouse_x - old_x ) * x, ( @mouse_y - old_y ) * y, w, h
            return @_catch_evt evt
            
        if @mouse_b == "LEFT" # rotate / C
            x = 2.0 * ( @mouse_x - old_x ) / mwh
            y = 2.0 * ( @mouse_y - old_y ) / mwh
            @cam.rotate y, x, 0.0
            return @_catch_evt evt
            
        return @_catch_evt evt
            
    # trouve un contexte adequat pour tracer dans le canvas
    _init_ctx: ->
        # try 3D
        if @allow_gl
            for t in [ "experimental-webgl", "webgl", "webkit-3d", "moz-webgl" ]
                try
                    if @ctx = @canvas.getContext t, opt_attribs
                        @ctx_type = "gl"
                        return true
                catch error
                    continue
        # -> 2D
        @ctx_type = "2d"
        @ctx = @canvas.getContext '2d'

    _get_x_min: ->
        @bounding_box()[ 0 ]

    _get_x_max: ->
        @bounding_box()[ 1 ]
        

    # compute and store camera info in @cam_info
    _mk_cam_info: ->
        w = @canvas.width
        h = @canvas.height
        
        i = {}
        for item in @active_items_rec()
            CanvasManager._get_active_items_in_an_hash_table_rec i, item
            
        @cam_info =
            w        : w
            h        : h
            mwh      : Math.min w, h
            ctx      : @ctx
            cam      : @cam
            get_x_min: => @_get_x_min()
            get_x_max: => @_get_x_max()
            re_2_sc  : @cam.re_2_sc w, h
            sc_2_rw  : @cam.sc_2_rw w, h
            sel_item : i
            time     : @time.get()
            theme    : @theme
            padding  : ( 1 - 1 / @padding_ratio ) * Math.min( w, h ) # padding size in pixels
                    
    # get leaves in item list (i.e. object with a draw method)
    @_get_flat_list: ( flat, item ) ->
        if item.sub_canvas_items?
            for sub_item in item.sub_canvas_items()
                CanvasManager._get_flat_list flat, sub_item

        if not item.has_nothing_to_draw?()
            flat.push item

    # fill an hash table with id of selected items
    @_get_active_items_in_an_hash_table_rec: ( i, item ) ->
        i[ item.model_id ] = true
        if item.sub_canvas_items?
            for n in item.sub_canvas_items()
                CanvasManager._get_active_items_in_an_hash_table_rec i, n
