class BarChart extends Drawable
    constructor: ( bar ) ->
        super()
        
        @add_attr
            points    : new Lst_Point
            legend    : new Lst
            axe_x     : ""
            axe_y     : ""
        
        @bar_width  = 2
        @bar_height = 150

    z_index: ->
        100

    build_w2b_legend: ->
        for i in [ 0 ... 255 ]
            color = ( if i < 16 then '0' else '' ) + i.toString 16
            @legend[ i ] = "#" + color + color + color

    draw: ( info ) ->
        if @points.length
        
            proj = for p in @points
                info.re_2_sc.proj p.pos.get()            
            
            if @legend.length == 0 #carefull with this line, it seems that length is always 0
                @build_w2b_legend()
            
            info.ctx.lineWidth = 1
            # draw points
                
            info.ctx.fillStyle = "#FFFFFF"
            for p, i in proj
                info.ctx.beginPath()
                info.ctx.fillStyle = @legend[ i ]
                info.ctx.fillRect p[ 0 ], p[ 1 ], @bar_width, @bar_height
                info.ctx.closePath()

    update_min_max: ( x_min, x_max ) ->
        for m in @points
            p = m.pos.get()
            for d in [ 0 ... 3 ]
                x_min[ d ] = Math.min x_min[ d ], p[ d ]
                x_max[ d ] = Math.max x_max[ d ], p[ d ]