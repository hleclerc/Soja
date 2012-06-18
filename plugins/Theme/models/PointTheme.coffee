# 
class PointTheme extends Model
    constructor: ( color, width, line_color, line_width )  ->
        super()
        
        @add_attr
            color     : color
            width     : width
            line_color: line_color
            line_width: line_width
            
    beg_ctx: ( info ) ->
        info.ctx.fillStyle   = @color.to_rgba()
        info.ctx.lineWidth   = @line_width.get()
        info.ctx.strokeStyle = @line_color.to_rgba()
        
    end_ctx: ( info ) ->
    
        
    draw_proj: ( info, proj ) ->
        info.ctx.beginPath()
        info.ctx.arc proj[ 0 ], proj[ 1 ], @width.get(), 0, Math.PI * 2, true
        info.ctx.fill()
        info.ctx.stroke()
        