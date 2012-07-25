# 
class ElementaryField extends Model
    constructor: ( name, data = new Lst, params = {} ) ->
        super()
        
        @add_attr
            _mesh: mesh
            _data: data
            
    get_drawing_parameters: ( model ) ->
        model.mod_attr
            drawing_parameters:
                display_style: new Choice( 0, [ "Points", "Wireframe", "Surface", "Surface with Edges" ] )
                legend       : new Legend( "todo" )
    
    
    get: () ->
        @_data.get()
    
    toString: ->
        @name.get()
    
    z_index: () ->
        return 140
        
    draw: ( info, parameters, additionnal_parameters ) ->
        if parameters.visualization?
            for tri, i in triangles
                @_draw_elementary_triangle info, parameters, tri.get(), proj, @_data[ i ], legend
    
    _draw_elementary_triangle: ( info, display_style, tri, proj, value, legend ) ->
        position = for i in [ 0 ... 3 ]
                proj[ tri[ i ] ]
        
        pos = ( legend.max_val.get() - value ) / ( legend.max_val.get() - legend.min_val.get() )
        col = legend.gradient.get_color_from_pos pos
        
        if display_style == "Wireframe"
            @_draw_elementary_stroke_triangle info, position, col
            
        if display_style == "Surface" or display_style == "Surface with Edges"
            @_draw_elementary_fill_triangle info, position, col
            
        if display_style == "Surface with Edges" or display_style == "Edges"
            @_draw_edge_triangle info, position
            
    # draw edges of triangle as normal lines
    _draw_edge_triangle: ( info, position ) ->
        info.ctx.beginPath()
        info.ctx.lineWidth = 1
        info.ctx.strokeStyle = info.theme.line_color.to_hex()
        info.ctx.moveTo( position[ 0 ][ 0 ], position[ 0 ][ 1 ] )
        info.ctx.lineTo( position[ 1 ][ 0 ], position[ 1 ][ 1 ] )
        info.ctx.lineTo( position[ 2 ][ 0 ], position[ 2 ][ 1 ] )
        info.ctx.lineTo( position[ 0 ][ 0 ], position[ 0 ][ 1 ] )
        info.ctx.stroke()        
        info.ctx.closePath() 
        
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
    