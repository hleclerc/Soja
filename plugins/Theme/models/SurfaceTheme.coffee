# 
class SurfaceTheme extends Model
    constructor: ( color = new Color( 200, 200, 200, 255 ) ) ->
        super()
        
        @add_attr
            color: color

    beg_ctx: ( info ) ->
        info.ctx.fillStyle = @color.to_rgba()
        
    end_ctx: ( info ) ->
        
    draw: ( info, func ) ->
        info.ctx.beginPath()
        func info
        info.ctx.fill()
        
    
        
