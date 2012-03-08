# This class is use to draw line/dot graph or bar chart
# params available :
# line        : true draw a line linking all points
# line_color  : choose the color of linking line_color (in html way (hexa or string))
# line_width  : width in pixels of line
# marker      : shape that mark all value : dot, cross, square or bar ( for bar chart )
# size_marker : indicate size in pixels of marker
# marker_color: choose the color of marker (in html way (hexa or string))
# font_color  : color of font in axis and legend
# x_axis      : label for x axis
# y_axis      : label for y axis
# legend_x_division : number of division on X legend including start and begining
# legend_y_division : number of division on y legend including start and begining

class Graph extends Drawable
    constructor: ( params = {} ) ->
        super()
        
        @add_attr
            points           : new Lst_Point
            legend           : new Lst
            line             : if params.line? then params.line else true
            line_color       : params.line_color or '#FFFFFF'
            line_width       : params.line_width or 1
            marker           : params.marker or 'dot'
            size_marker      : params.size_marker or 2
            marker_color     : params.marker_color or '#FFFFFF'
            font_color       : params.font_color or '#000000'
            x_axis           : params.x_axis or ''
            y_axis           : params.y_axis or ''
            legend_x_division: params.legend_x_division or 5
            legend_y_division: params.legend_y_division or 3
            sel_item    : new Lst
            
        @axis_width = 1
        @padding = 0 # in px

    z_index: ->
        100

    build_w2b_legend: ->
        for i in [ 0 .. 255 ]
            color = ( if i < 16 then '0' else '' ) + i.toString 16
            @legend[ i ] = "#" + color + color + color

    draw: ( info ) ->
        #draw points
        @draw_axis info
        
        @draw_legend info
        if @points.length
            orig = info.re_2_sc.proj [ 0, 0, 0 ]
            proj = for p in @points
                info.re_2_sc.proj p.pos.get()
                
            info.ctx.lineWidth = @line_width
            
            if @line.get() == true
                @draw_line info, orig, proj
            
            if @marker.get() == 'bar'
                @draw_marker_bar info, orig, proj
            else if @marker.get() == 'cross'
                @draw_marker_cross info, orig, proj
            else if @marker.get() == 'square'
                @draw_marker_square info, orig, proj
            else if @marker.get() == 'dot'
                @draw_marker_dot info, orig, proj
                
            # show value when mouse is over a point
            if @sel_item.length > 0
                @draw_highlight_values info
        
        
            
    draw_highlight_values: ( info ) ->
        highlighted_point = @points[ @sel_item[ 0 ] ].pos.get()
        info.ctx.beginPath()
        info.ctx.fillStyle = @font_color.get()
        info.ctx.textAlign = "right"
        info.ctx.font = "20px Arial"
        info.ctx.fillText highlighted_point[ 0 ] + ", " + highlighted_point[ 1 ] ,  info.w - @padding, 20
    
    
    draw_line: ( info, orig, proj ) ->
        #draw shadow
        info.ctx.strokeStyle = "#3a3a3a"
        info.ctx.beginPath()
        info.ctx.moveTo orig[ 0 ] + @padding + @line_width.get(), orig[ 1 ] - @padding + @line_width.get()
        for p, i in proj
            info.ctx.lineTo p[ 0 ] + @padding + @line_width.get(), p[ 1 ] - @padding + @line_width.get()
        info.ctx.stroke()
        info.ctx.closePath()
        
        #draw real line
        info.ctx.strokeStyle = @line_color.get()
        info.ctx.beginPath()
        info.ctx.moveTo orig[ 0 ] + @padding, orig[ 1 ] - @padding
        for p, i in proj
            info.ctx.lineTo p[ 0 ] + @padding, p[ 1 ] - @padding
        info.ctx.stroke()
        info.ctx.closePath()

    
    draw_marker_dot: ( info, orig, proj ) ->
        for p, i in proj
            info.ctx.beginPath()
            info.ctx.fillStyle = @legend[ i ] or @marker_color.get()
            info.ctx.arc p[ 0 ] + @padding, p[ 1 ] - @padding, @size_marker.get(), 0, Math.PI * 2, true
            info.ctx.fill()
        info.ctx.closePath()
        
    draw_marker_cross: ( info, orig, proj ) ->
        for p, i in proj
            info.ctx.beginPath()
            info.ctx.strokeStyle = @legend[ i ] or @marker_color.get()
            info.ctx.moveTo p[ 0 ] + @padding - @size_marker.get(), p[ 1 ] - @padding + @size_marker.get()
            info.ctx.lineTo p[ 0 ] + @padding + @size_marker.get(), p[ 1 ] - @padding - @size_marker.get()
            info.ctx.moveTo p[ 0 ] + @padding + @size_marker.get(), p[ 1 ] - @padding + @size_marker.get()
            info.ctx.lineTo p[ 0 ] + @padding - @size_marker.get(), p[ 1 ] - @padding - @size_marker.get()
            info.ctx.stroke()
        info.ctx.closePath()
        
    draw_marker_square: ( info, orig, proj ) ->
        for p, i in proj
            info.ctx.beginPath()
            info.ctx.fillStyle = @legend[ i ] or @marker_color.get()
            info.ctx.fillRect p[ 0 ] + @padding - @size_marker.get() * 0.5 , p[ 1 ] - @padding - @size_marker.get() * 0.5 , @size_marker.get(), @size_marker.get()
        info.ctx.closePath()
        
    #bar chart
    draw_marker_bar: ( info, orig, proj ) ->
        for p, i in proj
            #TODO clean this line and apply to all kind of draw
            if p[ 0 ] + @padding >= info.padding * 0.5 + @padding and p[ 0 ] + @padding <= (info.padding * 0.5 + @padding + info.w - info.padding + @size_marker.get() )
                height = orig[ 1 ] - p[ 1 ]
                
                info.ctx.beginPath()
                info.ctx.fillStyle = @legend[ i ] or @marker_color.get()
                info.ctx.fillRect p[ 0 ] + @padding, p[ 1 ] - @padding, @size_marker.get(), height
        info.ctx.closePath()
            
    draw_axis: ( info ) ->        
        orig = [ info.padding * 0.5 + @padding, info.h - info.padding / 2 - @padding, 0 ]
        width_axis = info.w - info.padding
        height_axis = -info.h + orig[ 1 ] + info.padding
        
        info.ctx.beginPath()
        info.ctx.lineWidth = @axis_width
        info.ctx.strokeStyle = @font_color.get()
        info.ctx.fillStyle = @font_color.get()
        info.ctx.font = "12px Arial"
        
        info.ctx.lineCap = "round"
        
        decal_txt = 10
        
        # x axis
        if @x_axis.get() != ""
            info.ctx.textAlign = "left"
            info.ctx.fillText @x_axis.get(), orig[ 0 ] + width_axis + decal_txt, orig[ 1 ] + 2
        info.ctx.moveTo orig[ 0 ], orig[ 1 ]
        info.ctx.lineTo orig[ 0 ] + width_axis, orig[ 1 ]
        
        # y axis
        if @y_axis.get() != ""
            info.ctx.textAlign = "center"
            info.ctx.fillText @y_axis.get(),  orig[ 0 ] - 2, height_axis - decal_txt
        info.ctx.moveTo orig[ 0 ], orig[ 1 ]
        info.ctx.lineTo orig[ 0 ], height_axis
        info.ctx.stroke()
        info.ctx.closePath()
        
    draw_legend: ( info ) ->
            
        x_padding_txt = 10
        y_padding_txt = 2
        decal_txt   = 3
                
        orig = [ 0 + info.padding * 0.5 + @padding, info.h - info.padding / 2 - @padding, 0]
        width_axis = info.w - info.padding/2
        height_axis = -info.h + orig[ 1 ] + info.padding
        
        info.ctx.beginPath()
        info.ctx.fillStyle = @font_color.get()
        info.ctx.font = '6pt Arial'
        
        info.ctx.textAlign = 'center'
        # x legend
        for i in [ 0 .. @legend_x_division ]
            pos = ( ( width_axis - decal_txt - ( orig[ 0 ] - decal_txt ) ) / ( @legend_x_division - 1 ) ) * i + orig[ 0 ]
            vve = info.sc_2_rw.pos pos, 0
            val = vve[ 0 ]
            info.ctx.fillText val.toFixed( 2 ), pos, orig[ 1 ] + x_padding_txt

        # y legend
        info.ctx.textAlign = 'right'
        for i in [ 0 .. @legend_y_division ]
            pos = ( ( height_axis + decal_txt - ( orig[ 1 ] + decal_txt ) ) / ( @legend_y_division - 1 ) ) * i + orig[ 1 ]

            val_from_screen = info.sc_2_rw.pos 0, pos
            val = val_from_screen[ 1 ]
            info.ctx.fillText val.toFixed(1),  orig[ 0 ] - y_padding_txt, pos + decal_txt
        
        info.ctx.fill()
        info.ctx.closePath()
    
    get_height_axis : ( info ) ->
        max = @get_max_point info
        info.re_2_sc.proj max.pos.get()

    update_min_max: ( x_min, x_max ) ->
        for m in @points
            p = m.pos.get()
            for d in [ 0 ... 3 ]
                x_min[ d ] = Math.min x_min[ d ], p[ d ]
                x_max[ d ] = Math.max x_max[ d ], p[ d ]
                
    get_movable_entities: ( res, info, pos, phase ) ->
        x = pos[ 0 ]
        y = pos[ 1 ]
        
        @sel_item.clear()
        if @points.length and phase == 0
            for p, i in @points
                proj = info.re_2_sc.proj p.pos.get()
                dx = x - proj[ 0 ]
                dy = y - proj[ 1 ]
                d = Math.sqrt dx * dx + dy * dy
                if d <= 10
                    @sel_item.push i
            