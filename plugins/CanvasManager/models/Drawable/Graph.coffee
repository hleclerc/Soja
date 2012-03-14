# This class is use to draw line/dot graph or bar chart
# params available :
# line        : true draw a line linking all points
# line_color  : choose the color of linking line_color (in html way (hexa or string))
# line_width  : width in pixels of line
# shadow      : boolean which represent if shadow on line must be drawn or not
# marker      : shape that mark all value : dot, cross, square or bar ( for bar chart )
# size_marker : indicate size in pixels of marker
# marker_color: choose the color of marker (in html way (hexa or string))
# font_color  : color of font in axis and legend
# font_size   : font size in pixels
# x_axis      : label for x axis
# y_axis      : label for y axis
# legend_x_division : number of division on X legend including start and begining
# legend_y_division : number of division on y legend including start and begining

class Graph extends Drawable
    constructor: ( params = {} ) ->
        super()
        
        @add_attr
            _sel_item        : new Lst
            line             : true
            line_color       : new Color 0, 0, 0 
            line_width       : new ConstrainedVal( 1, { min: 0, max: 20 } )
            shadow           : true
            marker           : new Choice( 0, [ "dot", "square", "cross", "diamond", "bar" ] )
            size_marker      : new ConstrainedVal( 5, { min: 0, max: 40 } )
            marker_color     : new Color 0, 0, 0
            font_color       : new Color 0, 0, 0
            font_size        : new ConstrainedVal( 12, { min: 2, max: 72 } )
            x_axis           : ''
            y_axis           : ''
            legend_x_division: 5
            legend_y_division: 3
            sel_item_color   : new Color 255, 255, 0
            movable_hl_infos : true
            points           : new Lst_Point
            legend           : new Lst

        for key, val of params
            this[ key ]?.set? val
        
        #        @add_attr
        #             _sel_item         : new Lst
        #             line             : if params.line? then params.line else true
        #             line_color       : params.line_color or new Color 0, 0, 0 
        #             line_width       : params.line_width or 1
        #             shadow           : if params.shadow? then params.shadow else true
        #             marker           : params.marker or 'dot'
        #             size_marker      : params.size_marker or 2
        #             marker_color     : params.marker_color or new Color 0, 0, 0
        #             font_color       : params.font_color or new Color 0, 0, 0
        #             x_axis           : params.x_axis or ''
        #             y_axis           : params.y_axis or ''
        #             legend_x_division: params.legend_x_division or 5
        #             legend_y_division: params.legend_y_division or 3
        #             sel_item_color   : params.sel_item_color or  new Color 255, 255, 0
        #             movable_hl_infos : if params.movable_hl_infos? then params.movable_hl_infos else true
        #             points           : new Lst_Point
        #             legend           : new Lst
            
        @axis_width = 1
#         @width_graph = 0
#         @height_graph = 0
        @origin = [ 0, 0 ]
        @O_point = [ 0, 0 ]
        @X_point = [ 0, 0 ]
        @Y_point = [ 0, 0 ]
        
    z_index: ->
        100

    build_w2b_legend: ->
        for i in [ 0 .. 255 ]
            color = ( if i < 16 then '0' else '' ) + i.toString 16
            @legend[ i ] = "#" + color + color + color

    draw: ( info ) ->
#         @width_graph  = info.w - info.padding * 2
#         @height_graph = info.h - info.padding * 2
#         @origin       = [ info.padding, info.h - info.padding ]
        @O_point  = [ info.padding / 2, info.h - info.padding ]
        @X_point  = [ info.w - info.padding / 2, info.h - info.padding ]
        @Y_point  = [ info.padding / 2, - info.h + info.padding ]
        
        info.ctx.lineCap = "round"
        info.ctx.lineJoin = "round"
        
        info.ctx.shadowOffsetX = 0
        info.ctx.shadowOffsetY = 0
        info.ctx.shadowBlur    = 0
        info.ctx.shadowColor   = "transparent black"
        
        #draw points
        if @points.length
            orig = info.re_2_sc.proj [ 0, 0, 0 ]
            proj = for p in @points
                info.re_2_sc.proj p.pos.get()
                
            if @shadow.get() == true
                #draw shadow
                @add_shadow info
            else
                @remove_shadow info
                
            if @line.get() == true
                @draw_line info, orig, proj
            
            if @marker.get() == 'bar'
                @draw_marker_bar info, orig, proj
            else if @marker.get() == 'cross'
                @draw_marker_cross info, orig, proj
            else if @marker.get() == 'square'
                @draw_marker_square info, orig, proj
            else if @marker.get() == 'diamond'
                @draw_marker_diamond info, orig, proj
            else if @marker.get() == 'dot'
                @draw_marker_dot info, orig, proj
                
            @remove_shadow info
            
            # show value when mouse is over a point
            if @_sel_item.length > 0
                if @movable_hl_infos.get() == true
                    @draw_movable_highlight_values info
                else
                    @draw_highlight_values info
        
        @hide_outside_values info
        
        @draw_axis info
        
        @draw_legend info
    
    add_shadow: ( info ) ->
        info.ctx.shadowOffsetX = @line_width.get()
        info.ctx.shadowOffsetY = @line_width.get()
        info.ctx.shadowBlur    = @line_width.get()
        info.ctx.shadowColor   =  "#3a3a3a"
        
        
    remove_shadow: ( info ) ->
        info.ctx.shadowOffsetX = 0
        info.ctx.shadowOffsetY = 0
        info.ctx.shadowBlur    = 0
        info.ctx.shadowColor   = "transparent black"
        
    
    hide_outside_values: ( info ) ->        
        info.ctx.fillStyle = "rgba(255, 255, 255, 0.9)"
        info.ctx.fillRect 0, 0, info.padding * 0.5, info.h
        info.ctx.fillRect info.padding * 0.5, info.h - info.padding / 2,info.w, info.padding * 0.5

    
    draw_movable_highlight_values: ( info ) ->
        padding_left = 10
        padding_top = -5
        
        #TODO should check if values don't go outside the canvas size
        
        highlighted_point = @points[ @_sel_item[ 0 ] ].pos.get()
        
        info.ctx.beginPath()
        pos = info.re_2_sc.proj highlighted_point
        
        text = highlighted_point[ 0 ] + ", " + highlighted_point[ 1 ]
        
        
        info.ctx.font = @font_size.get() * 2 + "px Arial"
        width_box = info.ctx.measureText( text ).width + padding_left * 2
        height_box = @font_size.get() * 3
#         
        info.ctx.fillStyle = "rgba(255, 255, 255, 0.8)"
        info.ctx.fillRect pos[ 0 ], pos[ 1 ] - height_box * 0.8, width_box, height_box
        info.ctx.lineWidth = 1
        info.ctx.strokeStyle = "rgba(0, 0, 0, 0.8)"
        info.ctx.strokeRect pos[ 0 ], pos[ 1 ] - height_box * 0.8, width_box, height_box
        
        info.ctx.textAlign = "left"
        info.ctx.fillStyle = @font_color.get()
        info.ctx.fillText text , pos[ 0 ] + padding_left, pos[ 1 ] + padding_top
        
    draw_highlight_values: ( info ) ->
        padding = 10
        highlighted_point = @points[ @_sel_item[ 0 ] ].pos.get()
        info.ctx.beginPath()
        info.ctx.fillStyle = @font_color.get()
        info.ctx.textAlign = "right"
        info.ctx.font = @font_size.get() * 2 + "px Arial"
        info.ctx.fillText highlighted_point[ 0 ] + ", " + highlighted_point[ 1 ] ,  info.w - padding , 20
    
    
    draw_line: ( info, orig, proj ) ->
        
        #draw real line
        info.ctx.beginPath()
        info.ctx.strokeStyle = @line_color.get()
        if @line_width.get() <= 1
            info.ctx.lineWidth = 1.000001 #fix a chromium bug
        else
            info.ctx.lineWidth = @line_width.get()
        for p, i in proj
            info.ctx.lineTo p[ 0 ], p[ 1 ]
        info.ctx.stroke()
        info.ctx.closePath()

    
    draw_marker_dot: ( info, orig, proj ) ->
        for p, i in proj
#             if p[ 0 ] >= @O_point[ 0 ] - @size_marker.get() and p[ 0 ] <= @X_point[ 0 ] + @size_marker.get()
            if @_sel_item.length > 0 and @_sel_item[ 0 ].get() == i
                info.ctx.fillStyle = @sel_item_color.get()
            else
                info.ctx.fillStyle = @legend[ i ] or @marker_color.get()
            info.ctx.beginPath()
            info.ctx.arc p[ 0 ], p[ 1 ], @size_marker.get() * 0.5, 0, Math.PI * 2, true
            info.ctx.fill()
        info.ctx.closePath()
        
    draw_marker_cross: ( info, orig, proj ) ->
        for p, i in proj
            if @_sel_item.length > 0 and @_sel_item[ 0 ].get() == i
                info.ctx.strokeStyle = @sel_item_color.get()
            else
                info.ctx.strokeStyle = @legend[ i ] or @marker_color.get()
                
            info.ctx.beginPath()
            info.ctx.moveTo p[ 0 ] - @size_marker.get() * 0.5, p[ 1 ] + @size_marker.get() * 0.5
            info.ctx.lineTo p[ 0 ] + @size_marker.get() * 0.5, p[ 1 ] - @size_marker.get() * 0.5
            info.ctx.moveTo p[ 0 ] + @size_marker.get() * 0.5, p[ 1 ] + @size_marker.get() * 0.5
            info.ctx.lineTo p[ 0 ] - @size_marker.get() * 0.5, p[ 1 ] - @size_marker.get() * 0.5
            info.ctx.stroke()
        info.ctx.closePath()
        
    draw_marker_square: ( info, orig, proj ) ->
        for p, i in proj
            if @_sel_item.length > 0 and @_sel_item[ 0 ].get() == i
                info.ctx.fillStyle = @sel_item_color.get()
            else
                info.ctx.fillStyle = @legend[ i ] or @marker_color.get()
            info.ctx.beginPath()
            info.ctx.fillRect p[ 0 ] - @size_marker.get() * 0.5 , p[ 1 ] - @size_marker.get() * 0.5 , @size_marker.get(), @size_marker.get()
        info.ctx.closePath()
        
    draw_marker_diamond: ( info, orig, proj ) ->
        for p, i in proj
            if @_sel_item.length > 0 and @_sel_item[ 0 ].get() == i
                info.ctx.fillStyle = @sel_item_color.get()
            else
                info.ctx.fillStyle = @legend[ i ] or @marker_color.get()
            info.ctx.beginPath()
            info.ctx.moveTo p[ 0 ], p[ 1 ] - @size_marker.get()
            info.ctx.lineTo p[ 0 ] + @size_marker.get() * 0.5, p[ 1 ]
            info.ctx.lineTo p[ 0 ], p[ 1 ] + @size_marker.get()
            info.ctx.lineTo p[ 0 ] - + @size_marker.get() * 0.5, p[ 1 ]
            info.ctx.fill()
        info.ctx.closePath()
        
    #bar chart
    draw_marker_bar: ( info, orig, proj ) ->
        for p, i in proj
            if @_sel_item.length > 0 and @_sel_item[ 0 ].get() == i
                info.ctx.fillStyle = @sel_item_color.get()
            else
                info.ctx.fillStyle = @legend[ i ] or @marker_color.get()
                
            height = orig[ 1 ] - p[ 1 ]
            
            info.ctx.beginPath()
            info.ctx.fillRect p[ 0 ], p[ 1 ], @size_marker.get(), height
        info.ctx.closePath()
            
    draw_axis: ( info ) ->
        orig = [ info.padding * 0.5, info.h - info.padding / 2, 0 ]
        width_axis = info.w - info.padding
        height_axis = -info.h + orig[ 1 ] + info.padding
        
        info.ctx.beginPath()
        info.ctx.lineWidth = @axis_width
        info.ctx.strokeStyle = @font_color.get()
        info.ctx.fillStyle = @font_color.get()
        info.ctx.font = @font_size.get() + "px Arial"
        
        
        decal_txt = 10
        
        # x axis
        if @x_axis.get() != ""
            info.ctx.textAlign = "left"
            info.ctx.fillText @x_axis.get(), orig[ 0 ] + width_axis + decal_txt, orig[ 1 ] + 2
        info.ctx.moveTo orig[ 0 ], orig[ 1 ]
        info.ctx.lineTo orig[ 0 ] + width_axis, orig[ 1 ]
        
        # y axis
        if @y_axis.get() != ""
            info.ctx.textBaseline = "bottom"
            info.ctx.textAlign = "center"
            info.ctx.fillText @y_axis.get(),  orig[ 0 ] - 2, height_axis - decal_txt
        info.ctx.moveTo orig[ 0 ], orig[ 1 ]
        info.ctx.lineTo orig[ 0 ], height_axis
        info.ctx.stroke()
        info.ctx.closePath()
        info.ctx.textBaseline = "middle"
        
    draw_legend: ( info ) ->
            
        x_padding_txt = 10
        y_padding_txt = 2
        decal_txt   = 3
                
        orig = [ 0 + info.padding * 0.5, info.h - info.padding / 2, 0]
        width_axis = info.w - info.padding/2
        height_axis = -info.h + orig[ 1 ] + info.padding
        
        info.ctx.beginPath()
        info.ctx.fillStyle = @font_color.get()
        info.ctx.font = @font_size.get() * 0.8 + "px Arial"
        
        info.ctx.textAlign = 'center'
        info.ctx.textBaseline = 'top'
        # x legend
        for i in [ 0 .. @legend_x_division.get() ]
            pos = orig[ 0 ] + ( ( width_axis - decal_txt - ( orig[ 0 ] - decal_txt ) ) / @legend_x_division.get() ) * i
            vve = info.sc_2_rw.pos pos, 0
            val = vve[ 0 ]
            size = Math.round(val).toString().length
            info.ctx.fillText val.toPrecision( size ), pos, orig[ 1 ] + x_padding_txt

        # y legend
        info.ctx.textBaseline = 'middle'
        info.ctx.textAlign = 'right'
        for i in [ 0 .. @legend_y_division.get() ]
            pos =  orig[ 1 ] + ( ( height_axis + decal_txt - ( orig[ 1 ] + decal_txt ) ) / @legend_y_division.get() ) * i

            val_from_screen = info.sc_2_rw.pos 0, pos
            val = val_from_screen[ 1 ]
            size = Math.round(val).toString().length
            info.ctx.fillText val.toPrecision( size ),  orig[ 0 ] - y_padding_txt, pos + decal_txt
        
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
        
        @_sel_item.clear()
        if @points.length and phase == 0
            for p, i in @points
                proj = info.re_2_sc.proj p.pos.get()
                dx = x - proj[ 0 ]
                dy = y - proj[ 1 ]
                d = Math.sqrt dx * dx + dy * dy
                if d <= @size_marker.get() * 2
                    @_sel_item.push i
            