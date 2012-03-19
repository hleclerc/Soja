class ZoomArea extends Drawable
    constructor: ( @canvas_manager, params = {} ) ->
        super()
        
        @add_attr
            zoom_factor: [ 10, 10, 1 ]
            zoom_pos   : [ -1, -1, 0 ]
        
        for key, val of params
            this[ key ]?.set? val
        
    z_index: ->
        1000

    on_mouse_move: ( x, y ) ->
        @zoom_pos[ 0 ].set x
        @zoom_pos[ 1 ].set y
        
    draw: ( info ) ->
        clientX = @zoom_pos[ 0 ].get()
        clientY = @zoom_pos[ 1 ].get()
        zx = @zoom_factor[ 0 ].get()
        zy = @zoom_factor[ 1 ].get()
        
        n_info = {}
        for key, val of info
            n_info[ key ] = val
        
        n_info.re_2_sc =
            proj: ( p ) ->
                np = info.re_2_sc.proj p
                [
                    zx * ( np[ 0 ] - clientX ) + clientX,
                    zy * ( np[ 1 ] - clientY ) + clientY,
                    p[ 2 ]
                ]
        
        #         n_info.re_2_sc = ( info, pos ) ->
        #             res = info.re_2_sc.proj pos
        #             res[ 0 ] *= @zoom_factor[ 0 ]
        #             res[ 1 ] *= @zoom_factor[ 1 ]
        #             res[ 2 ] *= @zoom_factor[ 2 ]
        #             return res
        
        # Create a circular clipping path
        info.ctx.save()
        info.ctx.beginPath()
        
        info.ctx.strokeStyle = 'yellow'
        info.ctx.lineWidth = 2
        info.ctx.arc clientX, clientY, 100, 0, Math.PI*2, true
        info.ctx.stroke()
        
        info.ctx.clip()
        
        for it in @canvas_manager._flat when it != this
            it.draw n_info
            
        info.ctx.restore()

