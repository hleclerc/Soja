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
                info.ctx.fillRect p[ 0 ], p[ 1 ], @bar_width, height
                info.ctx.closePath()
        
        @drawAxis info
        
        @drawLegend info

#     get_width_axis : ( info ) ->
#         info.re_2_sc.proj [ @points.length, 0, 0 ]
#       
#     get_max_point: ( info ) ->
#         max = @points[ 0 ]
#         max_val = max.pos[ 1 ].get()
#         for p in @points
#             if p.pos[ 1 ].get() > max_val
#                 max = p
#                 max_val = p.pos[ 1 ].get()
#         
#         return max
#     
#     get_height_axis : ( info ) ->
#         max = @get_max_point info
#         info.re_2_sc.proj max.pos.get()
        
    drawAxis: ( info ) ->
    
        orig = [ info.padding/2, info.h - info.padding/2, 0]
        width_axis = info.w - info.padding/2
        height_axis = -info.h + orig[ 1 ] + info.padding
        
        info.ctx.beginPath()
        info.ctx.lineWidth = 2
        info.ctx.strokeStyle = "white"
        
        info.ctx.lineCap = "round"
        
        decal_txt = 10
        
        # x axis
#         info.ctx.strokeText "X",  width_axis + decal_txt, orig[ 1 ] + 2
        info.ctx.moveTo orig[ 0 ], orig[ 1 ]
        info.ctx.lineTo width_axis, orig[ 1 ]
        
        # y axis
#         info.ctx.strokeText "Y",  orig[ 0 ] - 2, - height_axis - decal_txt
        info.ctx.moveTo orig[ 0 ], orig[ 1 ]
        info.ctx.lineTo orig[ 0 ], height_axis
        info.ctx.stroke()
        info.ctx.closePath()
        
    drawLegend: ( info ) ->
    
        orig = [ 0 + info.padding / 2, info.h - info.padding / 2, 0]
        width_axis = info.w - info.padding/2
        height_axis = -info.h + orig[ 1 ] + info.padding
        
        info.ctx.beginPath()
        info.ctx.lineWidth = 2
        info.ctx.fillStyle = "white"
        
        info.ctx.font = '6pt Arial'
        
        padding_txt = 10
        decal_txt   = 3
        
        # y legend
        info.ctx.fillText "0",  orig[ 0 ] - padding_txt, orig[ 1 ] + decal_txt
        info.ctx.fillText "val_max",  orig[ 0 ] - padding_txt, height_axis + decal_txt
        
        # x legend
        info.ctx.fillText "0",  orig[ 0 ] - decal_txt , orig[ 1 ] + padding_txt
        info.ctx.fillText "255",  width_axis - decal_txt , orig[ 1 ] + padding_txt
        info.ctx.fill()
        info.ctx.closePath()
    
    update_min_max: ( x_min, x_max ) ->
        for m in @points
            p = m.pos.get()
            for d in [ 0 ... 3 ]
                x_min[ d ] = Math.min x_min[ d ], p[ d ]
                x_max[ d ] = Math.max x_max[ d ], p[ d ]