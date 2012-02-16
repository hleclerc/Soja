class BarChart extends Drawable
    constructor: ( x_axis = '', y_axis = '' ) ->
        super()
        
        @add_attr
            points    : new Lst_Point
            legend    : new Lst
            x_axis    : x_axis
            y_axis    : y_axis
        
        @bar_width = 2
        @axis_width = 1
        @padding = 10 # in px

    z_index: ->
        100

    build_w2b_legend: ->
        for i in [ 0 .. 255 ]
            color = ( if i < 16 then '0' else '' ) + i.toString 16
            @legend[ i ] = "#" + color + color + color

    draw: ( info ) ->
        
        #draw points
        if @points.length
        
            orig = info.re_2_sc.proj [ 0, 0, 0]
            proj = for p in @points
                info.re_2_sc.proj p.pos.get()
                
            info.ctx.lineWidth = 1
            info.ctx.fillStyle = "#FFFFFF"
            for p, i in proj
                height = orig[ 1 ] - p[ 1 ]
                
                info.ctx.beginPath()
                info.ctx.fillStyle = @legend[ i ]
                info.ctx.fillRect p[ 0 ] + @padding, p[ 1 ] - @padding, @bar_width, height
                info.ctx.closePath()
        
        @drawAxis info
        
        @drawLegend info

    drawAxis: ( info ) ->
        
        orig = [ info.padding * 0.5 + @padding, info.h - info.padding / 2 - @padding, 0]
        width_axis = info.w - info.padding/2
        height_axis = -info.h + orig[ 1 ] + info.padding
        
        info.ctx.beginPath()
        info.ctx.lineWidth = @axis_width
        info.ctx.strokeStyle = "white"
        
        info.ctx.lineCap = "round"
        
        decal_txt = 10
        
        # x axis
        if @x_axis.get() != ""
            info.ctx.strokeText @x_axis.get(),  width_axis + decal_txt, orig[ 1 ] + 2
        info.ctx.moveTo orig[ 0 ], orig[ 1 ]
        info.ctx.lineTo width_axis, orig[ 1 ]
        
        # y axis
        if @y_axis.get() != ""
            info.ctx.strokeText @y_axis.get(),  orig[ 0 ] - 2, height_axis - decal_txt
        info.ctx.moveTo orig[ 0 ], orig[ 1 ]
        info.ctx.lineTo orig[ 0 ], height_axis
        info.ctx.stroke()
        info.ctx.closePath()
        
    drawLegend: ( info ) ->
    
        # number of division including start and begining
        x_division = 5
        y_division = 3
        
        x_padding_txt = 10
        y_padding_txt = 2
        decal_txt   = 3
        
#         console.log info.sc_2_rw @points[ 0 ][ 0 ],@points[ 0 ][ 1 ]
        
        orig = [ 0 + info.padding * 0.5 + @padding, info.h - info.padding / 2 - @padding, 0]
        width_axis = info.w - info.padding/2
        height_axis = -info.h + orig[ 1 ] + info.padding
        
        info.ctx.beginPath()
        info.ctx.fillStyle = "white"
        info.ctx.font = '6pt Arial'
        
        x_min = @get_x_min_point info
        x_max = @get_x_max_point info
        
        info.ctx.textAlign = 'center'
        # x legend
        for i in [ 0 .. x_division ]
            val = ( ( x_max - x_min ) / ( x_division - 1 ) ) * i + x_min
            pos = ( ( width_axis - decal_txt - ( orig[ 0 ] - decal_txt ) ) / ( x_division - 1 ) ) * i + orig[ 0 ] - decal_txt
            info.ctx.fillText val.toFixed(2),  pos, orig[ 1 ] + x_padding_txt
        
#         info.ctx.fillText x_min,  orig[ 0 ] - decal_txt , orig[ 1 ] + padding_txt
#         info.ctx.fillText x_max,  width_axis - decal_txt , orig[ 1 ] + padding_txt


        y_min = @get_y_min_point info
        y_max = @get_y_max_point info

        # y legend
#         info.ctx.fillText y_min,  orig[ 0 ] - padding_txt, orig[ 1 ] + decal_txt
#         info.ctx.fillText y_max,  orig[ 0 ] - padding_txt, height_axis + decal_txt
        info.ctx.textAlign = 'right'
        for i in [ 0 .. y_division ]
            val = ( ( y_max - y_min ) / ( y_division - 1 ) ) * i + y_min
            pos = ( ( height_axis + decal_txt - ( orig[ 1 ] + decal_txt ) ) / ( y_division - 1 ) ) * i + orig[ 1 ] + decal_txt
            info.ctx.fillText val.toFixed(1),  orig[ 0 ] - y_padding_txt, pos
        
        info.ctx.fill()
        info.ctx.closePath()

#     get_width_axis : ( info ) ->
#         info.re_2_sc.proj [ @points.length, 0, 0 ]
#       
    get_y_max_point: ( info ) ->
        max_val = @points[ 0 ].pos[ 1 ].get()
        for p in @points
            if p.pos[ 1 ].get() > max_val
                max_val = p.pos[ 1 ].get()
        return max_val
        
    get_x_max_point: ( info ) ->
        max_val = @points[ 0 ].pos[ 0 ].get()
        for p in @points
            if p.pos[ 0 ].get() > max_val
                max_val = p.pos[ 0 ].get()
        return max_val
        
    get_y_min_point: ( info ) ->
        min_val = @points[ 0 ].pos[ 1 ].get()
        for p in @points
            if p.pos[ 1 ].get() < min_val
                min_val = p.pos[ 1 ].get()
        return min_val
        
    get_x_min_point: ( info ) ->
        min_val = @points[ 0 ].pos[ 0 ].get()
        for p in @points
            if p.pos[ 0 ].get() < min_val
                min_val = p.pos[ 0 ].get()
        return min_val
    
    get_height_axis : ( info ) ->
        max = @get_max_point info
        info.re_2_sc.proj max.pos.get()

    update_min_max: ( x_min, x_max ) ->
        for m in @points
            p = m.pos.get()
            for d in [ 0 ... 3 ]
                x_min[ d ] = Math.min x_min[ d ], p[ d ]
                x_max[ d ] = Math.max x_max[ d ], p[ d ]