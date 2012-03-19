class ZoomArea extends Drawable
    constructor: ( @canvas_manager, params = {} ) ->
        super()
        
        @add_attr
            zoom_factor: [ 2, 2, 1 ]
        
        for key, val of params
            this[ key ]?.set? val
        
    z_index: ->
        1000

    draw: ( info ) ->
        clientX = @canvas_manager.old_x
        clientY = @canvas_manager.old_y
        re_2_sc: ( info, pos ) ->
            res = info.re_2_sc.proj pos
            res[ 0 ] *= @zoom_factor[ 0 ]
            res[ 1 ] *= @zoom_factor[ 1 ]
            res[ 2 ] *= @zoom_factor[ 2 ]
            return res
        
        # Create a circular clipping path
        info.ctx.save()
        info.ctx.beginPath()
        
        info.ctx.strokeStyle = 'yellow'
        info.ctx.lineWidth = 2
        info.ctx.arc clientX, clientY, 100, 0, Math.PI*2, true
        info.ctx.stroke()
        
        info.ctx.clip()
        
        
        for it in @canvas_manager._flat when it != this
            it.draw info
            
        info.ctx.restore()

