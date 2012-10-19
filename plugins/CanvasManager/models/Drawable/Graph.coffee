# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2012 Hugo Leclerc
#
# This file is part of Soda.
#
# Soda is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Soda is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with Soda. If not, see <http://www.gnu.org/licenses/>.



# This class is use to draw line/dot graph or bar chart
# params available :
# show_line   : boolean which represent if a line linking all points must be drawn or not
# line_color  : choose the color of linking line_color (in html way (hexa or string))
# line_width  : width in pixels of line
# shadow      : boolean which represent if shadow on line must be drawn or not
# show_marker : boolean which represent if marker must be drawn or not
# marker      : shape that mark all value : dot, cross, square or bar ( for bar chart )
# marker_size : indicate size in pixels of marker
# marker_color: choose the color of marker (in html way (hexa or string))
# font_color  : color of font in axis and legend
# font_size   : font size in pixels
# show_grid   : boolean which represent if grid must be drawn or not
# grid_color  : choose the color of grid (in html way (hexa or string))
# x_axis      : label for x axis
# y_axis      : label for y axis
# legend_x_division : number of division on X legend including start and begining
# legend_y_division : number of division on y legend including start and begining

class Graph extends Drawable
    constructor: ( params = {} ) ->
        super()
        
        @add_attr
            show_line        : true
            line_color       : new Color 0, 0, 0 
            line_width       : new ConstrainedVal( 1, { min: 0, max: 20 } )
            shadow           : true
            show_marker      : true
            marker           : new Choice( 0, [ "dot", "square", "cross", "diamond", "bar" ] )
            marker_size      : new ConstrainedVal( 5, { min: 0, max: 40 } )
            marker_color     : new Color 0, 0, 0
            font_color       : new Color 0, 0, 0
            font_size        : new ConstrainedVal( 12, { min: 2, max: 72 } )
            show_grid        : true
            grid_color       : new Color 200, 200, 200
            x_axis           : ''
            y_axis           : ''
            legend_x_division: 5
            legend_y_division: 3
            sel_item_color   : new Color 255, 255, 0
            movable_hl_infos : true
            points           : new Lst_Point
            legend           : new Lst
            # behavior
            _pre_sele        : new Lst # references of selected points

        for key, val of params
            this[ key ]?.set? val
        
        #        @add_attr
        #             line             : if params.line? then params.line else true
        #             line_color       : params.line_color or new Color 0, 0, 0 
        #             line_width       : params.line_width or 1
        #             shadow           : if params.shadow? then params.shadow else true
        #             marker           : params.marker or 'dot'
        #             marker_size      : params.marker_size or 2
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
                
            if @show_grid.get() == true
                @draw_grid info
                
            if @shadow.get() == true
                #draw shadow
                @add_shadow info
            else
                @remove_shadow info
                
            if @show_line.get() == true
                @draw_line info, orig, proj
                
            if @show_marker.get() == true
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
            
            if @show_marker.get() == true
                # show value when mouse is over a point
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
        info.ctx.fillStyle = "rgba( 255, 255, 255, 0.9 )"
        info.ctx.clearRect 0, 0, info.padding * 0.5, info.h
        info.ctx.clearRect info.padding * 0.5, info.h - info.padding / 2,info.w, info.padding * 0.5
    
    draw_movable_highlight_values: ( info ) ->
        padding_left = 10
        padding_top = -8
        decal_left = 10
        decal_top = -12
        
        #TODO should check if values don't go outside the canvas size
        for p, i in @points
            if @points[ i ] in @_pre_sele
                highlighted_point = p.pos.get()
                info.ctx.beginPath()
                pos = info.re_2_sc.proj highlighted_point
                
                text = highlighted_point[ 0 ] + ", " + highlighted_point[ 1 ]
                
                
                info.ctx.font = @font_size.get() * 2 + "px Arial"
                width_box = info.ctx.measureText( text ).width + padding_left * 2
                height_box = @font_size.get() * 3
        #         
                info.ctx.fillStyle = "rgba(255, 255, 255, 0.8)"
                info.ctx.fillRect pos[ 0 ] + decal_left, pos[ 1 ] + decal_top - height_box * 0.8, width_box, height_box
                info.ctx.lineWidth = 1
                info.ctx.strokeStyle = "rgba(0, 0, 0, 0.8)"
                info.ctx.strokeRect pos[ 0 ] + decal_left, pos[ 1 ] + decal_top - height_box * 0.8, width_box, height_box
                
                info.ctx.textAlign = "left"
                info.ctx.fillStyle = @font_color.to_rgba()
                info.ctx.fillText text , pos[ 0 ] + padding_left + decal_left, pos[ 1 ] + padding_top + decal_top
        
    draw_highlight_values: ( info ) ->
        padding = 10
        for p, i in @points
            if @points[ i ] in @_pre_sele
                highlighted_point = p.pos.get()
                info.ctx.beginPath()
                info.ctx.fillStyle = @font_color.to_rgba()
                info.ctx.textAlign = "right"
                info.ctx.font = @font_size.get() * 2 + "px Arial"
                info.ctx.fillText highlighted_point[ 0 ] + ", " + highlighted_point[ 1 ] ,  info.w - padding , 20
    
    
    draw_line: ( info, orig, proj ) ->
        #draw real line
        info.ctx.beginPath()
        info.ctx.strokeStyle = @line_color.to_rgba()
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
            if @points[ i ] in @_pre_sele
                info.ctx.fillStyle = @sel_item_color.to_rgba()
            else
                info.ctx.fillStyle = @legend[ i ] or @marker_color.to_rgba()
            info.ctx.beginPath()
            info.ctx.arc p[ 0 ], p[ 1 ], @marker_size.get() * 0.5, 0, Math.PI * 2, true
            info.ctx.fill()
        info.ctx.closePath()
        
    draw_marker_cross: ( info, orig, proj ) ->
        for p, i in proj
            if @points[ i ] in @_pre_sele
                info.ctx.strokeStyle = @sel_item_color.to_rgba()
            else
                info.ctx.strokeStyle = @legend[ i ] or @marker_color.to_rgba()
                
            info.ctx.beginPath()
            info.ctx.moveTo p[ 0 ] - @marker_size.get() * 0.5, p[ 1 ] + @marker_size.get() * 0.5
            info.ctx.lineTo p[ 0 ] + @marker_size.get() * 0.5, p[ 1 ] - @marker_size.get() * 0.5
            info.ctx.moveTo p[ 0 ] + @marker_size.get() * 0.5, p[ 1 ] + @marker_size.get() * 0.5
            info.ctx.lineTo p[ 0 ] - @marker_size.get() * 0.5, p[ 1 ] - @marker_size.get() * 0.5
            info.ctx.stroke()
        info.ctx.closePath()
        
    draw_marker_square: ( info, orig, proj ) ->
        for p, i in proj
            if @points[ i ] in @_pre_sele
                info.ctx.fillStyle = @sel_item_color.to_rgba()
            else
                info.ctx.fillStyle = @legend[ i ] or @marker_color.to_rgba()
            info.ctx.beginPath()
            info.ctx.fillRect p[ 0 ] - @marker_size.get() * 0.5 , p[ 1 ] - @marker_size.get() * 0.5 , @marker_size.get(), @marker_size.get()
        info.ctx.closePath()
        
    draw_marker_diamond: ( info, orig, proj ) ->
        for p, i in proj
            if @points[ i ] in @_pre_sele
                info.ctx.fillStyle = @sel_item_color.to_rgba()
            else
                info.ctx.fillStyle = @legend[ i ] or @marker_color.to_rgba()
            info.ctx.beginPath()
            info.ctx.moveTo p[ 0 ], p[ 1 ] - @marker_size.get()
            info.ctx.lineTo p[ 0 ] + @marker_size.get() * 0.5, p[ 1 ]
            info.ctx.lineTo p[ 0 ], p[ 1 ] + @marker_size.get()
            info.ctx.lineTo p[ 0 ] - + @marker_size.get() * 0.5, p[ 1 ]
            info.ctx.fill()
        info.ctx.closePath()
        
    #bar chart
    draw_marker_bar: ( info, orig, proj ) ->
        for p, i in proj
            if @points[ i ] in @_pre_sele
                info.ctx.fillStyle = @sel_item_color.to_rgba()
            else
                info.ctx.fillStyle = @legend[ i ] or @marker_color.to_rgba()
                
            height = orig[ 1 ] - p[ 1 ]
            
            info.ctx.beginPath()
            info.ctx.fillRect p[ 0 ], p[ 1 ], @marker_size.get(), height
        info.ctx.closePath()
            
    draw_axis: ( info ) ->
        orig = [ info.padding * 0.5, info.h - info.padding / 2, 0 ]
        width_axis = info.w - info.padding
        height_axis = -info.h + orig[ 1 ] + info.padding
        
        info.ctx.beginPath()
        info.ctx.lineWidth = @axis_width
        info.ctx.strokeStyle = @font_color.to_rgba()
        info.ctx.fillStyle = @font_color.to_rgba()
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
        decal_txt_X   = 3
        decal_txt_Y   = 1
                
        orig = [ 0 + info.padding * 0.5, info.h - info.padding / 2, 0]
        width_axis = info.w - info.padding/2
        height_axis = -info.h + orig[ 1 ] + info.padding
        
        info.ctx.beginPath()
        info.ctx.fillStyle = @font_color.to_rgba()
        info.ctx.font = @font_size.get() * 0.8 + "px Arial"
        
        info.ctx.textAlign = 'center'
        info.ctx.textBaseline = 'top'
        # x legend
        value = []
        posit = []
        for i in [ 0 .. @legend_x_division.get() ]
            pos = orig[ 0 ] + ( ( width_axis - decal_txt_X - ( orig[ 0 ] - decal_txt_X ) ) / @legend_x_division.get() ) * i
            vve = info.sc_2_rw.pos pos, 0
            val = vve[ 0 ]
            value.push val
            posit.push pos
#             size = Math.round(val).toString().length
#             info.ctx.fillText val.toPrecision( size ), pos, orig[ 1 ] + x_padding_txt

        [ min, max ] = @get_min_max_of_array value
        
        for i in [ 0 .. @legend_x_division.get() ]
            nice_val = @get_significative_number value[ i ], [ min, max ]
            info.ctx.fillText nice_val, posit[ i ], orig[ 1 ] + x_padding_txt
            
            
        # y legend
        info.ctx.textBaseline = 'middle'
        info.ctx.textAlign = 'right'
        value = []
        posit = []
        for i in [ 0 .. @legend_y_division.get() ]
            pos =  orig[ 1 ] + ( ( height_axis + decal_txt_Y - ( orig[ 1 ] + decal_txt_Y ) ) / @legend_y_division.get() ) * i
            val_from_screen = info.sc_2_rw.pos 0, pos
            val = val_from_screen[ 1 ]
            value.push val
            posit.push pos
        [ min, max ] = @get_min_max_of_array value
        
        for i in [ 0 .. @legend_y_division.get() ]
            nice_val = @get_significative_number value[ i ], [ min, max ]
            info.ctx.fillText nice_val,  orig[ 0 ] - y_padding_txt, posit[ i ] + decal_txt_Y
        
        info.ctx.fill()
        info.ctx.closePath()
    
    
    get_min_max_of_array: ( array ) ->        
        min = array[ 0 ]
        for el in array
            if el < min
                min = el
        max = array[ 0 ]
        for el in array
            if el > max
                max = el
        return [ min, max ]
        
    
    get_significative_number: ( val, [ min, max ] ) ->
#         console.log "-----------"
#         console.log val, min, max
        size = Math.abs( max - min )
#         console.log size
        
        if size > 1
            res = Math.round(val)
            if res.toString().length > 4
                res = res.toExponential()
        else 

            num = Math.round(val).toString().length
#             console.log num
            if num <= 4
                res = val.toPrecision( num + 2 )
                
                #for tiny number search how many number 0 after coma
                for c, i in val.toString()
                    if c != "0" and c != "." and c != "-"
                        number = i
                        break;
#                 console.log "num " + number + " size " + size
                if number > 3
                    res = parseFloat(res).toExponential()
            else
                res = val.toFixed(2)
#         console.log res
        return res
    
    draw_grid: ( info ) ->
        orig = [ 0 + info.padding * 0.5, info.h - info.padding / 2, 0]
        width_axis = info.w - info.padding/2
        height_axis = -info.h + orig[ 1 ] + info.padding
        
        info.ctx.beginPath()
        info.ctx.strokeStyle = @grid_color.to_rgba()
        
        # vertical line
        for i in [ 1 ... @legend_x_division.get() ]
            pos = orig[ 0 ] + ( ( width_axis - orig[ 0 ] ) / @legend_x_division.get() ) * i
            info.ctx.moveTo pos, orig[ 1 ]
            info.ctx.lineTo pos, height_axis
            info.ctx.stroke()
            
            
        # horizontal line
        for i in [ 1 ... @legend_y_division.get() ]
            pos =  orig[ 1 ] + ( ( height_axis - orig[ 1 ] ) / @legend_y_division.get() ) * i
            info.ctx.moveTo orig[ 0 ], pos
            info.ctx.lineTo orig[ 0 ] + info.w - info.padding, pos
        
        info.ctx.stroke()
        info.ctx.closePath()
        
        
        
#     get_height_axis : ( info ) ->
#         max = @get_max_point info
#         info.re_2_sc.proj max.pos.get()

    update_min_max: ( x_min, x_max ) ->
        for m in @points
            p = m.pos.get()
            for d in [ 0 ... 3 ]
                x_min[ d ] = Math.min x_min[ d ], p[ d ]
                x_max[ d ] = Math.max x_max[ d ], p[ d ]
                

    on_mouse_move: ( cm, evt, pos, b, old ) ->
        # pre selection
        res = []
        x = pos[ 0 ]
        y = pos[ 1 ]
        
        if @points.length
            for p, i in @points
                proj = cm.cam_info.re_2_sc.proj p.pos.get()
                dx = x - proj[ 0 ]
                dy = y - proj[ 1 ]
                d = Math.sqrt dx * dx + dy * dy
                if d <= @marker_size.get() * 2
                    res.push
                        item: p
                        dist: d
        if res.length
            res.sort ( a, b ) -> b.dist - a.dist
            if @_pre_sele.length != 1 or @_pre_sele[ 0 ] != res[ 0 ].item
                @_pre_sele.clear()
                @_pre_sele.push res[ 0 ].item
                
        else if @_pre_sele.length
            @_pre_sele.clear()
            
        return false