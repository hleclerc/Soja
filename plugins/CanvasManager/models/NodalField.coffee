# 
class NodalField extends Model
    constructor: ( name, data = new Lst, params = {} ) ->
        super()
        
        @add_attr
            name           : name
            _data          : data
    
    get: () ->
        @_data.get()
        
    toString: ->
        @name.get()

#     dim: ->
#         3
        
    
    draw: ( info, display_style, triangles, proj, legend) ->
        for tri in triangles
            @_draw_nodal_triangle info, display_style, tri.get(), proj, @_data, legend
            
    
    # the trick of this function is that it use only one linear gradient calculate using point value and position
    _draw_nodal_triangle: ( info, display_style, tri, proj, field, legend ) ->
        posit = for i in [ 0 ... 3 ]
            proj[ tri[ i ] ]
                
        value = for i in [ 0 ... 3 ]
            field[ tri[ i ] ]
                
        max_legend = legend.max_val.get()
        min_legend = legend.min_val.get()
        
        for val, i in value
            value[ i ] = ( max_legend - val ) / ( max_legend - min_legend )
            
        # position of every point
        x0 = posit[ 0 ][ 0 ]
        y0 = posit[ 0 ][ 1 ]
        
        x1 = posit[ 1 ][ 0 ]
        y1 = posit[ 1 ][ 1 ]
        
        x2 = posit[ 2 ][ 0 ]
        y2 = posit[ 2 ][ 1 ]
        
        mat_pos = [ [ 1, x0, y0 ], [ 1, x1, y1 ], [ 1, x2, y2 ] ]
        det = Vec_3.determinant mat_pos
        
        mat_a = [ [ value[ 0 ], x0, y0 ], [ value[ 1 ], x1, y1 ], [ value[ 2 ], x2, y2 ] ]
        det_a = Vec_3.determinant mat_a
        a = det_a / det
                    
        mat_b = [ [ 1, value[ 0 ], y0 ], [ 1, value[ 1 ], y1 ], [ 1, value[ 2 ], y2 ] ]
        det_b = Vec_3.determinant mat_b
        b = det_b / det
        
        mat_c = [ [ 1, x0, value[ 0 ] ], [ 1, x1, value[ 1 ] ], [ 1, x2, value[ 2 ] ] ]
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
        
        if display_style == "Wireframe"
            @_draw_gradient_stroke_triangle info, p0, p1, posit, legend
            
        if display_style == "Surface" or display_style == "Surface with Edges"
            @_draw_gradient_fill_triangle info, p0, p1, posit, legend
            
        if display_style == "Surface with Edges" or display_style == "Lines"
            @_draw_edge_triangle info, posit
            
    # draw edges of triangle as normal lines
    _draw_edge_triangle: ( info, posit ) ->
        info.ctx.beginPath()
        info.ctx.lineWidth = 1
        info.ctx.strokeStyle = info.theme.line.to_hex()
        info.ctx.moveTo( posit[ 0 ][ 0 ], posit[ 0 ][ 1 ] )
        info.ctx.lineTo( posit[ 1 ][ 0 ], posit[ 1 ][ 1 ] )
        info.ctx.lineTo( posit[ 2 ][ 0 ], posit[ 2 ][ 1 ] )
        info.ctx.lineTo( posit[ 0 ][ 0 ], posit[ 0 ][ 1 ] )
        info.ctx.stroke()        
        info.ctx.closePath() 
                
    # drawing gradient depending p0 and p1 in the correct triangle with the correct color
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
