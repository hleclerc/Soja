# 
class Element_TriangleList extends Element
    constructor: ( points = new TypedArray_Float64 [ 0, 3 ] )->
        super()
        
        @add_attr
            indices: new TypedArray_Int32 [ 0, 3 ]
            
    draw: ( info, mesh, proj, is_a_sub ) ->
        if mesh.visualization.display_style.get() in [ "Surface" ]
            info.theme.surfaces.beg_ctx info
            
            info.theme.surfaces.draw info, =>
                for i in [ 0 ... @indices.size( 0 ) ]
                    info.ctx.moveTo proj[ @indices.get [ i, 0 ] ][ 0 ], proj[ @indices.get [ i, 0 ] ][ 1 ]
                    info.ctx.lineTo proj[ @indices.get [ i, 1 ] ][ 0 ], proj[ @indices.get [ i, 1 ] ][ 1 ]
                    info.ctx.lineTo proj[ @indices.get [ i, 2 ] ][ 0 ], proj[ @indices.get [ i, 2 ] ][ 1 ]
                    info.ctx.lineTo proj[ @indices.get [ i, 0 ] ][ 0 ], proj[ @indices.get [ i, 0 ] ][ 1 ]

            info.theme.surfaces.end_ctx info
            
    # the trick of this function is that it use only one linear gradient calculate using point value and position
    draw_nodal_field: ( info, proj, field, display_style, legend ) ->
        for num_triangle in [ 0 ... @indices.size( 0 ) ]
            tri = [
                @indices.get [ num_triangle, 0 ]
                @indices.get [ num_triangle, 1 ]
                @indices.get [ num_triangle, 2 ]
            ]
            
                    
            vals = [
                field.get tri[ 0 ]
                field.get tri[ 1 ]
                field.get tri[ 2 ]
            ]
                
            posit = for i in [ 0 ... 3 ]
                proj[ tri[ i ] ]
                
                    
            max_legend = legend.max_val.get()
            min_legend = legend.min_val.get()
            
            for val, i in vals
                vals[ i ] = ( max_legend - val ) / ( max_legend - min_legend )
                
            # position of every point
            x0 = posit[ 0 ][ 0 ]
            y0 = posit[ 0 ][ 1 ]
            
            x1 = posit[ 1 ][ 0 ]
            y1 = posit[ 1 ][ 1 ]
            
            x2 = posit[ 2 ][ 0 ]
            y2 = posit[ 2 ][ 1 ]
            
            mat_pos = [ [ 1, x0, y0 ], [ 1, x1, y1 ], [ 1, x2, y2 ] ]
            det = Vec_3.determinant mat_pos
            
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
            
            #p0[ 0 ] = Math.min( Math.max( p0[ 0 ], -16000 ), 16000 )
            #p0[ 1 ] = Math.min( Math.max( p0[ 1 ], -16000 ), 16000 )
            #p1[ 0 ] = Math.min( Math.max( p1[ 0 ], -16000 ), 16000 )
            #p1[ 1 ] = Math.min( Math.max( p1[ 1 ], -16000 ), 16000 )
                        
            if display_style == "Surface" or display_style == "Surface with Edges"
                @_draw_gradient_fill_triangle info, p0, p1, posit, legend
                
            if display_style == "Surface with Edges" or display_style == "Edges"
                @_draw_edge_triangle info, posit
                
            if display_style == "Wireframe"
                @_draw_gradient_stroke_triangle info, p0, p1, posit, legend
                
    # draw edges of triangle as normal lines
    _draw_edge_triangle: ( info, posit ) ->
        info.theme.lines.beg_ctx info
        info.theme.lines.draw_straight_proj info, posit[ 0 ], posit[ 1 ]
        info.theme.lines.draw_straight_proj info, posit[ 1 ], posit[ 2 ]
        info.theme.lines.draw_straight_proj info, posit[ 2 ], posit[ 0 ]
        info.theme.lines.end_ctx info
                
    # wireframe. drawing gradient depending p0 and p1 in the correct triangle with the correct color
    _draw_gradient_stroke_triangle: ( info, p0, p1, posit, legend ) ->
        info.ctx.beginPath()
        lineargradient = info.ctx.createLinearGradient p0[ 0 ], p0[ 1 ], p1[ 0 ], p1[ 1 ]
        for col in legend.gradient.color_stop
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
        lineargradient = info.ctx.createLinearGradient p0[ 0 ], p0[ 1 ], p1[ 0 ], p1[ 1 ]
        for col in legend.gradient.color_stop
            lineargradient.addColorStop col.position.get(), col.color.to_rgba()
        info.ctx.strokeStyle = lineargradient
        info.ctx.fillStyle = lineargradient
        info.ctx.moveTo( posit[ 0 ][ 0 ], posit[ 0 ][ 1 ] )
        info.ctx.lineTo( posit[ 1 ][ 0 ], posit[ 1 ][ 1 ] )
        info.ctx.lineTo( posit[ 2 ][ 0 ], posit[ 2 ][ 1 ] )
        info.ctx.lineTo( posit[ 0 ][ 0 ], posit[ 0 ][ 1 ] )
        info.ctx.fill()
        info.ctx.stroke()
