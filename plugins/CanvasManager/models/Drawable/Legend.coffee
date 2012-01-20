#
class Legend extends Drawable
    constructor: ( title = "" )->
        super()
        
        @add_attr
            gradient: new Gradient
            title   : title
            _min_val: 0
            _max_val: 0
            _width  : 30
            _height : 300
            
        @gradient.add_color [ 255,255,255, 255 ], 0
        @gradient.add_color [   0,  0,  0, 255 ], 1
        
    z_index: () ->
        return 1000
        
    draw_text_legend: ( info ) ->  
        pos_y = info.h * 0.5 - @_height.get() * 0.5
        pos_x = info.w - @_width.get() - @_width.get() * 3
        info.ctx.font = "14pt Arial"
        info.ctx.fillStyle = "White"
        info.ctx.textAlign = "right"
        for c_s in @gradient.color_stop
            pos = c_s.position.get()
            val = ( @_max_val.get() - @_min_val.get() ) * ( 1 - c_s.position.get() ) + @_min_val.get()
            info.ctx.fillText( val.toFixed( 1 ), pos_x - 8, pos_y + 7 + pos * @_height.get() )
    
    draw: ( info ) ->
        pos_y = info.h * 0.5 - @_height.get() * 0.5
        pos_x = info.w - @_width.get() - @_width.get() * 3
        lineargradient = info.ctx.createLinearGradient( 0, pos_y, 0, pos_y + @_height.get() )
        for col in @gradient.color_stop
            lineargradient.addColorStop( col.position.get(), "rgba(#{col.color.r.get()}, #{col.color.g.get()}, #{col.color.b.get()}, #{col.color.a.get()})" )
        info.ctx.fillStyle = lineargradient
        info.ctx.fillRect( pos_x, pos_y, @_width.get(), @_height.get() )
        
        @draw_text_legend info
        
        info.ctx.font = "20pt Arial"
        info.ctx.textAlign = "center"
        info.ctx.fillText( @title, pos_x + @_width.get() * 0.5, pos_y + @_height.get() + @_height.get() * 0.2 )

    