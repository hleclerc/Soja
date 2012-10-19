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



# 
class Element_TriangleList extends Element
    constructor: ->
        super()
        
        @add_attr
            indices: new TypedArray_Int32 [ 3, 0 ]
            
    draw: ( info, mesh, proj, is_a_sub ) ->
        if mesh.visualization.display_style.get() in [ "Surface", "Surface with Edges" ]
            lt = for i in [ 0 ... @indices.size( 1 ) ]
                [
                    proj[ @indices.get [ 0, i ] ]
                    proj[ @indices.get [ 1, i ] ]
                    proj[ @indices.get [ 2, i ] ]
                ]
                
            lt.sort ( a, b ) -> ( b[ 0 ][ 2 ] + b[ 1 ][ 2 ] + b[ 2 ][ 2 ] ) - ( a[ 0 ][ 2 ] + a[ 1 ][ 2 ] + a[ 2 ][ 2 ] )
            
            for pl in lt
                info.theme.surfaces.beg_ctx info
                
                info.theme.surfaces.draw info, =>
                    info.ctx.moveTo pl[ 0 ][ 0 ], pl[ 0 ][ 1 ]
                    info.ctx.lineTo pl[ 1 ][ 0 ], pl[ 1 ][ 1 ]
                    info.ctx.lineTo pl[ 2 ][ 0 ], pl[ 2 ][ 1 ]
                    info.ctx.lineTo pl[ 0 ][ 0 ], pl[ 0 ][ 1 ]

                info.theme.surfaces.end_ctx info

        if mesh.visualization.display_style.get() in [ "Wireframe", "Surface with Edges" ]
            info.theme.lines.beg_ctx info
            
            for i in [ 0 ... @indices.size( 1 ) ]
                p = for j in [ 0 ... 3 ]
                    proj[ @indices.get [ j, i ] ]
                info.theme.lines.draw_straight_proj info, p[ 0 ], p[ 1 ]
                info.theme.lines.draw_straight_proj info, p[ 1 ], p[ 2 ]
                info.theme.lines.draw_straight_proj info, p[ 2 ], p[ 0 ]

            info.theme.lines.end_ctx info
                
    # the trick of this function is that it use only one linear gradient calculate using point value and position
    draw_nodal_field: ( info, proj, data, display_style, legend ) ->
        max_legend = legend.max_val.get()
        min_legend = legend.min_val.get()
        div_legend = max_legend - min_legend
        div_legend = 1 / ( div_legend + ( div_legend == 0 ) )
        
        indices = for num_triangle in [ 0 ... @indices.size( 1 ) ]
            [
                @indices.get [ 0, num_triangle ]
                @indices.get [ 1, num_triangle ]
                @indices.get [ 2, num_triangle ]
            ]
            
        indices.sort ( a, b ) -> ( proj[ b[ 0 ] ][ 2 ] + proj[ b[ 1 ] ][ 2 ] + proj[ b[ 2 ] ][ 2 ] ) - ( proj[ a[ 0 ] ][ 2 ] + proj[ a[ 1 ] ][ 2 ] + proj[ a[ 2 ] ][ 2 ] )
        
        for tri in indices
            vals = [
                data.get tri[ 0 ]
                data.get tri[ 1 ]
                data.get tri[ 2 ]
            ]

            for val, i in vals
                vals[ i ] = ( max_legend - val ) * div_legend
                
            #             c = max_legend - min_legend + ( max_legend == min_legend )
            #             vals = for i in [ 0 ... 3 ]
            #                 ( data.get( tri[ i ] ) - min_legend ) / c
            
            posit = for i in [ 0 ... 3 ]
                proj[ tri[ i ] ]
                
                    
            # position of every point
            x0 = posit[ 0 ][ 0 ]
            y0 = posit[ 0 ][ 1 ]
            
            x1 = posit[ 1 ][ 0 ]
            y1 = posit[ 1 ][ 1 ]
            
            x2 = posit[ 2 ][ 0 ]
            y2 = posit[ 2 ][ 1 ]
            
            mat_pos = [ [ 1, x0, y0 ], [ 1, x1, y1 ], [ 1, x2, y2 ] ]
            det = Vec_3.determinant mat_pos
            det += det == 0
            #             if isNaN det
            #                 console.log proj, tri
            
            mat_a = [ [ vals[ 0 ], x0, y0 ], [ vals[ 1 ], x1, y1 ], [ vals[ 2 ], x2, y2 ] ]
            det_a = Vec_3.determinant mat_a
            a = det_a / det
                        
            mat_b = [ [ 1, vals[ 0 ], y0 ], [ 1, vals[ 1 ], y1 ], [ 1, vals[ 2 ], y2 ] ]
            det_b = Vec_3.determinant mat_b
            b = det_b / det
            
            mat_c = [ [ 1, x0, vals[ 0 ] ], [ 1, x1, vals[ 1 ] ], [ 1, x2, vals[ 2 ] ] ]
            det_c = Vec_3.determinant mat_c
            c = det_c / det
                
            # getting p0
            if b or c
                if Math.abs( b ) > Math.abs( c )
                    p0x0 = - a / b
                    p0y0 = 0
                else
                    p0x0 = 0
                    p0y0 = - a / c
            else
                p0x0 = 0
                p0y0 = 0
                
            p0 = [ p0x0, p0y0, 0 ]
            
            # getting p1
            p1ieqz = ( x ) -> x + ( Math.abs( x ) < 1e-16 )
            alpha = 1 / p1ieqz( b * b + c * c )
            p1 = Vec_3.add( p0, Vec_3.mus( alpha, [ b, c, 0 ] ) )
            #             if isNaN( p0[ 0 ] ) or isNaN( p0[ 1 ] ) or isNaN( p1[ 0 ] ) or isNaN( p1[ 1 ] )
            #                 console.log mat_pos
            #             p0[ 0 ] = Math.min( Math.max( p0[ 0 ], -16000 ), 16000 )
            #             p0[ 1 ] = Math.min( Math.max( p0[ 1 ], -16000 ), 16000 )
            #             p1[ 0 ] = Math.min( Math.max( p1[ 0 ], -16000 ), 16000 )
            #             p1[ 1 ] = Math.min( Math.max( p1[ 1 ], -16000 ), 16000 )
                        
            if display_style == "Surface" or display_style == "Surface with Edges"
                @_draw_gradient_fill_triangle info, p0, p1, posit, legend
                
            if display_style == "Surface with Edges" or display_style == "Edges"
                @_draw_edge_triangle info, posit
                
            if display_style == "Wireframe"
                @_draw_gradient_stroke_triangle info, p0, p1, posit, legend
                
                
    # wireframe. drawing gradient depending p0 and p1 in the correct triangle with the correct color
    _draw_gradient_stroke_triangle: ( info, p0, p1, posit, legend ) ->
        info.ctx.beginPath()
        lineargradient = info.ctx.createLinearGradient p0[ 0 ], p0[ 1 ], p1[ 0 ], p1[ 1 ]
        for col in legend.color_map.color_stop
            lineargradient.addColorStop col.position.get(), col.color.to_rgba()
        info.ctx.strokeStyle = lineargradient
        info.ctx.moveTo( posit[ 0 ][ 0 ], posit[ 0 ][ 1 ] )
        info.ctx.lineTo( posit[ 1 ][ 0 ], posit[ 1 ][ 1 ] )
        info.ctx.lineTo( posit[ 2 ][ 0 ], posit[ 2 ][ 1 ] )
        info.ctx.lineTo( posit[ 0 ][ 0 ], posit[ 0 ][ 1 ] )
        info.ctx.stroke()
        
    # drawing gradient depending p0 and p1 in the correct triangle
    _draw_gradient_fill_triangle: ( info, p0, p1, posit, legend ) ->
        info.ctx.beginPath()
        if isNaN( p0[ 0 ] ) or isNaN( p0[ 1 ] ) or isNaN( p1[ 0 ] ) or isNaN( p1[ 1 ] )
            return
        if Math.abs( p0[ 0 ] ) > 1e40 or Math.abs( p0[ 1 ] ) > 1e40 or Math.abs( p1[ 0 ] ) > 1e40 or Math.abs( p1[ 1 ] ) > 1e40
            return
        lineargradient = info.ctx.createLinearGradient p0[ 0 ], p0[ 1 ], p1[ 0 ], p1[ 1 ]
        for col in legend.color_map.color_stop
            lineargradient.addColorStop col.position.get(), col.color.to_rgba()
        info.ctx.strokeStyle = lineargradient
        info.ctx.fillStyle = lineargradient
        info.ctx.moveTo( posit[ 0 ][ 0 ], posit[ 0 ][ 1 ] )
        info.ctx.lineTo( posit[ 1 ][ 0 ], posit[ 1 ][ 1 ] )
        info.ctx.lineTo( posit[ 2 ][ 0 ], posit[ 2 ][ 1 ] )
        info.ctx.lineTo( posit[ 0 ][ 0 ], posit[ 0 ][ 1 ] )
        info.ctx.fill()
        info.ctx.stroke()
        
        
    draw_elementary_triangle: ( info, proj, data, display_style, legend ) ->
        max_legend = legend.max_val.get()
        min_legend = legend.min_val.get()
        div_legend = max_legend - min_legend
        div_legend = 1 / ( div_legend + ( div_legend == 0 ) )
        for num_triangle in [ 0 ... @indices.size( 1 ) ]
            tri = [
                @indices.get [ 0, num_triangle ]
                @indices.get [ 1, num_triangle ]
                @indices.get [ 2, num_triangle ]
            ]
                    
            value = data.get num_triangle

#             for val, i in vals
#                 vals[ i ] = ( max_legend - val ) * div_legend
                
            #             c = max_legend - min_legend + ( max_legend == min_legend )
            #             vals = for i in [ 0 ... 3 ]
            #                 ( field.get( tri[ i ] ) - min_legend ) / c
            
            position = for i in [ 0 ... 3 ]
                proj[ tri[ i ] ]
    
    
            pos = ( max_legend - value ) / ( max_legend - min_legend )
            col = legend.color_map.get_color_from_pos pos
            
            if display_style == "Wireframe"
                @_draw_elementary_stroke_triangle info, position, col
                
            if display_style == "Surface" or display_style == "Surface with Edges"
                @_draw_elementary_fill_triangle info, position, col
                
            if display_style == "Surface with Edges" or display_style == "Edges"
                @_draw_edge_triangle info, position
            
        
    # draw edges of triangle with adapted color
    _draw_elementary_stroke_triangle: ( info, position, col ) ->
        info.ctx.beginPath()        
        info.ctx.strokeStyle = "rgba( " + col[ 0 ] + ", " + col[ 1 ] + ", " + col[ 2 ] + ", " + col[ 3 ] + " ) "
        info.ctx.moveTo( position[ 0 ][ 0 ], position[ 0 ][ 1 ] )
        info.ctx.lineTo( position[ 1 ][ 0 ], position[ 1 ][ 1 ] )
        info.ctx.lineTo( position[ 2 ][ 0 ], position[ 2 ][ 1 ] )
        info.ctx.lineTo( position[ 0 ][ 0 ], position[ 0 ][ 1 ] )
        info.ctx.stroke()        
        info.ctx.closePath()
        
    # draw surface of triangle
    _draw_elementary_fill_triangle: ( info, position, col ) ->
        info.ctx.beginPath()
        info.ctx.fillStyle = "rgba( " + col[ 0 ] + ", " + col[ 1 ] + ", " + col[ 2 ] + ", " + col[ 3 ] + " ) "
        info.ctx.strokeStyle = "rgba( " + col[ 0 ] + ", " + col[ 1 ] + ", " + col[ 2 ] + ", " + col[ 3 ] + " ) "
        info.ctx.moveTo( position[ 0 ][ 0 ], position[ 0 ][ 1 ] )
        info.ctx.lineTo( position[ 1 ][ 0 ], position[ 1 ][ 1 ] )
        info.ctx.lineTo( position[ 2 ][ 0 ], position[ 2 ][ 1 ] )
        info.ctx.lineTo( position[ 0 ][ 0 ], position[ 0 ][ 1 ] )
        info.ctx.fill()
        info.ctx.stroke()
        info.ctx.closePath()
        
    # draw edges of triangle as normal lines
    _draw_edge_triangle: ( info, posit ) ->
        info.theme.lines.beg_ctx info
        info.theme.lines.draw_straight_proj info, posit[ 0 ], posit[ 1 ]
        info.theme.lines.draw_straight_proj info, posit[ 1 ], posit[ 2 ]
        info.theme.lines.draw_straight_proj info, posit[ 2 ], posit[ 0 ]
        info.theme.lines.end_ctx info