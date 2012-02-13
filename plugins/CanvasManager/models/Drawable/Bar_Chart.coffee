class BarChart extends Drawable
    constructor: ( bar ) ->
        super()
        
        @add_attr
            points    : new Lst_Point
            legend    : new Lst
            axe_x     : ""
            axe_y     : ""
        
        @bar_width = 2

    z_index: ->
        100

    build_w2b_legend: ->
        for i in [ 0 .. 255 ]
            color = ( if i < 16 then '0' else '' ) + i.toString 16
            @legend[ i ] = "#" + color + color + color

    draw: ( info ) ->
        orig = info.re_2_sc.proj [0, 0, 0]
        
        @drawAxis info, orig
        
        #draw points
        if @points.length
        
            
            proj = for p in @points
                info.re_2_sc.proj p.pos.get()
                
            info.ctx.lineWidth = 1
            info.ctx.fillStyle = "#FFFFFF"
            for p, i in proj
                height = orig[ 1 ] - p[ 1 ]
                
                info.ctx.beginPath()
                info.ctx.fillStyle = @legend[ i ]
                info.ctx.fillRect p[ 0 ], p[ 1 ], @bar_width, height
                info.ctx.closePath()

    get_width_axis : ( info ) ->
        info.re_2_sc.proj [ @points.length, 0, 0 ]
      
    get_max_point: ( info ) ->
        max = @points[ 0 ]
        max_val = max.pos[ 1 ].get()
        for p in @points
            if p.pos[ 1 ].get() > max_val
                max = p
                max_val = p.pos[ 1 ].get()
        
        return max
    
    get_height_axis : ( info ) ->
        max = @get_max_point info
        info.re_2_sc.proj max.pos.get()
        
    drawAxis: ( info, orig ) ->
        width_axis = @get_width_axis info
        height_axis = @get_height_axis info
        
        info.ctx.beginPath()
        info.ctx.lineWidth = 2
        info.ctx.strokeStyle = "#FFFFFF"
        
        # x axis
        info.ctx.moveTo orig[ 0 ], orig[ 1 ]
        info.ctx.lineTo width_axis[ 0 ], orig[ 1 ]
        
        console.log orig
        console.log width_axis, height_axis
        # y axis
        info.ctx.moveTo orig[ 0 ], orig[ 1 ]
        info.ctx.lineTo orig[ 0 ], height_axis[ 1 ]
        info.ctx.stroke()
        info.ctx.closePath()
    
    update_min_max: ( x_min, x_max ) ->
        for m in @points
            p = m.pos.get()
            for d in [ 0 ... 3 ]
                x_min[ d ] = Math.min x_min[ d ], p[ d ]
                x_max[ d ] = Math.max x_max[ d ], p[ d ]