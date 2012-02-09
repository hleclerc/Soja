#
class Legend extends Drawable
    constructor: ( title = "", show_legend = true )->
        super()
        
        @add_attr
            show_legend: show_legend
            gradient   : new Gradient
            title      : title
            min_val    : 0
            max_val    : 0
            _width     : 30
            _height    : 300
            
        @gradient.add_color [ 255,255,255, 255 ], 0
        @gradient.add_color [   0,  0,  0, 255 ], 1
        
    z_index: () ->
        return 1000
    
    get_ratio: ( info ) ->
        info.h / ( @_height.get() * 1.7 )
    
    draw_text_legend: ( info ) ->
        
        ratio = @get_ratio info
        height = @_height.get() * ratio
        width = @_width.get() * ratio
        
        pos_y = info.h * 0.5 - height * 0.5
        pos_x = info.w - width - width * 2.5
        font_size = 13 * ratio 
        info.ctx.font = font_size + "pt Arial"
        info.ctx.fillStyle = "White"
        info.ctx.textAlign = "right"
        for c_s in @gradient.color_stop
            pos = c_s.position.get()
            val = ( @max_val.get() - @min_val.get() ) * ( 1 - c_s.position.get() ) + @min_val.get()
            info.ctx.fillText( val.toFixed( 1 ), pos_x - 8, pos_y + 7 + pos * height )
    
    draw: ( info ) ->
        if @show_legend.get() == true
            
            ratio = @get_ratio info
            height = @_height.get() * ratio
            width = @_width.get() * ratio
            
            pos_y = info.h * 0.5 - height * 0.5
            pos_x = info.w - width - width * 2.5
            lineargradient = info.ctx.createLinearGradient( 0, pos_y, 0, pos_y + height )
            for col in @gradient.color_stop
                lineargradient.addColorStop( col.position.get(), "rgba(#{col.color.r.get()}, #{col.color.g.get()}, #{col.color.b.get()}, #{col.color.a.get()})" )
            info.ctx.fillStyle = lineargradient
            info.ctx.fillRect( pos_x, pos_y, width, height )
            
            @draw_text_legend info
            
            font_size = 18 * ratio 
            
            info.ctx.font = font_size + "pt Arial"
            info.ctx.textAlign = "center"
            info.ctx.fillText( @title, pos_x + width * 0.5, pos_y + height + height * 0.2 )

    