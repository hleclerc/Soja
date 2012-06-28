# Vectorial fields is a list containing differents field
class VectorialField extends Drawable
    constructor: ( name = "", vector = new Lst, params = {} ) ->
        super()
        
        @add_attr
            _vector     : vector
    
            
    get_drawing_parameters: ( model ) ->
        if @_vector.length
            @_vector[ 0 ].get_drawing_parameters model
            model.visualization.add_attr
                norm: new Choice( 0, [ "norm_2" ] )
    
    get: ->
        return @_vector.get()

    dim: ->
        if @_vector
            return @_vector.length
        return 0
        
    add_child: ( child ) ->
        @_vector.push child
        
    rem_child: ( child ) ->
        ind = @_vector.indexOf child
        if ind > 0
            @_vector.splice ind, 1
    
    get_value_of_fields_at_index: ( index ) ->
        value = new Lst
        if @dim() > 0
            for field in @_vector.get()
                if field[ index ]?
                    value.push field[ index ]
                else
                    value.push 0
        return value
    
    z_index: () ->
        return 75
        
    draw: ( info, display_style, points, values, warp_factor = 1, legend ) ->
        if display_style == "Arrow"
            color = "white"
            
            arrow_reduce = 0.3
            arrow_width_factor = 0.1
            
            for p, ind in points
                
                element = new Lst
                for data, i in @_vector
                    element.push data.get()[ ind ] * warp_factor
                if element.length == 2
                    element.push 0
                     
                proj_p0 = info.re_2_sc.proj p.pos.get()
                proj_p1 = info.re_2_sc.proj Vec_3.add( p.pos.get(), element.get() )
                
                orthogo = [ proj_p0[ 1 ] - proj_p1[ 1 ], proj_p1[ 0 ] - proj_p0[ 0 ] ]

                arrow_p0 = [
                    ( 1 - arrow_reduce ) * proj_p1[ 0 ] + arrow_reduce * proj_p0[ 0 ] + arrow_width_factor * orthogo[ 0 ],
                    ( 1 - arrow_reduce ) * proj_p1[ 1 ] + arrow_reduce * proj_p0[ 1 ] + arrow_width_factor * orthogo[ 1 ]
                ]
                arrow_p1 = [
                    ( 1 - arrow_reduce ) * proj_p1[ 0 ] + arrow_reduce * proj_p0[ 0 ] - arrow_width_factor * orthogo[ 0 ],
                    ( 1 - arrow_reduce ) * proj_p1[ 1 ] + arrow_reduce * proj_p0[ 1 ] - arrow_width_factor * orthogo[ 1 ]
                ]
                
                max_legend = legend.max_val.get()
                min_legend = legend.min_val.get()
                position = ( max_legend - values[ ind ] ) / ( max_legend - min_legend )
                color = legend.gradient.get_color_from_pos position
                
                @_draw_arrow_colored info, proj_p0, proj_p1, arrow_p0, arrow_p1, color
            
    _draw_arrow_colored: ( info, p0, p1, arrow_p0, arrow_p1, color ) ->
        info.ctx.beginPath()
        info.ctx.lineWidth = 1
        info.ctx.strokeStyle = "rgba( " + color[ 0 ] + ", " + color[ 1 ] + ", " + color[ 2 ] + ", " + color[ 3 ] + " ) "
        info.ctx.moveTo( p0[ 0 ], p0[ 1 ] )
        info.ctx.lineTo( p1[ 0 ], p1[ 1 ] )
        info.ctx.stroke()
        
        #drawing arrow
        info.ctx.fillStyle = "rgba( " + color[ 0 ] + ", " + color[ 1 ] + ", " + color[ 2 ] + ", " + color[ 3 ] + " ) "
        info.ctx.lineWidth = 0.8        
        info.ctx.moveTo( p1[ 0 ], p1[ 1 ] )
        info.ctx.lineTo( arrow_p0[ 0 ], arrow_p0[ 1 ] )
        info.ctx.lineTo( arrow_p1[ 0 ], arrow_p1[ 1 ] )
        info.ctx.lineTo( p1[ 0 ], p1[ 1 ] )
        info.ctx.fill()
        info.ctx.stroke()
        
        info.ctx.closePath() 
