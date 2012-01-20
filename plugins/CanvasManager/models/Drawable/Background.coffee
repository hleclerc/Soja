#
class Background extends Drawable
    constructor: ()->
        super()


        @add_attr
            gradient: new Gradient
            
        @gradient.add_color [  0,  0,    0, 255 ], 0
        @gradient.add_color [ 76, 76,  100, 255 ], 1
        
    z_index: () ->
        return 0
        
    draw: ( info ) ->
        lineargradient = info.ctx.createLinearGradient( 0, 0, 0, info.h )
        for col in @gradient.color_stop
            lineargradient.addColorStop col.position.get(), col.color.to_rgba()
        info.ctx.fillStyle = lineargradient
        info.ctx.fillRect( 0, 0, info.w, info.h )
        