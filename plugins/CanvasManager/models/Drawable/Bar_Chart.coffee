class Bar_Chart extends Drawable
    constructor: ( bar ) ->
        super()
        
        @add_attr
            points    : new Lst_Point
            legend    : new Lst
            axe_x     : ""
            axe_y     : ""
        
        bar_width  = 2
        bar_height = 100

    z_index: ->
        100

    draw: ( info ) ->
        if @points.length
            info.ctx.lineWidth = 1
            # draw points
            for p in @points
                info.ctx.strokeStyle = "#00FF00"
                info.ctx.fillStyle = "#00FF00"
                info.ctx.beginPath()
                info.ctx.arc p[ 0 ], p[ 1 ], 4, 0, Math.PI * 2, true
#                 info.ctx.closePath()
                info.ctx.fill()
                info.ctx.stroke()
                info.ctx.fillStyle = "#FFFFFF"
                info.ctx.fillRect( p[ 0 ], p[ 1 ], @bar_width, @bar_height)

    update_min_max: ( x_min, x_max ) ->
        for m in @points
            p = m.pos.get()
            for d in [ 0 ... 3 ]
                x_min[ d ] = Math.min x_min[ d ], p[ d ]
                x_max[ d ] = Math.max x_max[ d ], p[ d ]