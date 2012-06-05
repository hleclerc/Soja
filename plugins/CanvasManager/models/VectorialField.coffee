# Vectorial fields is a list containing differents field
class VectorialField extends Model
    constructor: ( name = "", vector = new Lst, params = {} ) ->
        super()
        
        @add_attr
            name        : name
            _vector     : vector
    
    
    get: () ->
        return @_vector.get()
    
    toString: ->
        @name.get()

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
            for field in @_vector
                if field[ index ]?#probably not working
                    value.push field[ index ]
                else
                    value.push 0
        return value
    
    draw: ( info, display_style, points, values, legend ) ->
        if display_style == "Arrow"
            color = "white"
            
            arrow_reduce = 0.3
            
            for p, ind in points
                element = new Lst
                for data, i in @_vector
                    element.push data.get()[ ind ]
                if element.length == 2
                    element.push 0
                p0 = info.re_2_sc.proj p.pos.get()
                p1 = info.re_2_sc.proj Vec_3.add( p.pos.get(), element.get() )
                dist = Vec_3.dist p0, p1
                size_arrow = dist * arrow_reduce
                p_init = new Vec_3 [ 0, 0, 0 ]
                p_init[ 0 ] = p0[ 0 ] + ( p1[ 0 ] - p0[ 0 ] ) * arrow_reduce
                p_init[ 1 ] = p0[ 1 ] + ( p1[ 1 ] - p0[ 1 ] ) * arrow_reduce

                arrow_p0 = p0
                arrow_p1 = p1
                
                max_legend = legend.max_val.get()
                min_legend = legend.min_val.get()
                position = ( max_legend - values[ ind ] ) / ( max_legend - min_legend )
                color = legend.gradient.get_color_from_pos position
                
                @_draw_arrow_colored info, p0, p1, arrow_p0, arrow_p1, color
            
    _draw_arrow_colored: ( info, p0, p1, arrow_p0, arrow_p1, color ) ->
            
        info.ctx.beginPath()
        info.ctx.lineWidth = 1
        info.ctx.strokeStyle = "rgba( " + color[ 0 ] + ", " + color[ 1 ] + ", " + color[ 2 ] + ", " + color[ 3 ] + " ) "
        info.ctx.moveTo( p0[ 0 ], p0[ 1 ] )
        info.ctx.lineTo( p1[ 0 ], p1[ 1 ] )
        
        #drawing arrow
        info.ctx.lineTo( arrow_p0[ 0 ], arrow_p0[ 1 ] )
        info.ctx.moveTo( p1[ 0 ], p1[ 1 ] )
        info.ctx.lineTo( arrow_p1[ 0 ], arrow_p1[ 1 ] )
        
        info.ctx.stroke()        
        info.ctx.closePath() 
