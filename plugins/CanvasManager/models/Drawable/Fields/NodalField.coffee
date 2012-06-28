# 
class NodalField extends Model
    constructor: ( mesh ) ->
        super()
        
        @add_attr
            _mesh: mesh
            _data: new TypedArray_Float64( mesh?.nb_points?() )
            
    get_drawing_parameters: ( model ) ->
        model.add_attr
            drawing_parameters:
                display_style: new Choice( 2, [ "Points", "Wireframe", "Surface", "Surface with Edges" ] )
                legend       : new Legend( "todo" )
            
    
    toString: ->
        @name.get()

    draw: ( info, parameters ) ->
        if parameters?
            proj = for p, i in @_mesh.points
                info.re_2_sc.proj p.pos.get()

            @actualise_value_legend @_data.get(), parameters.legend
            for el in @_mesh._elements
                el.draw_nodal_field? info, proj, @_data, parameters.display_style.get(), parameters.legend

    z_index: ->
        return 50
        
    
    actualise_value_legend: ( values, legend ) ->
        max = @_get_max values
        legend.max_val.set max
        
        min = @_get_min values
        legend.min_val.set min
        
        
    _get_max: ( l ) ->
        if l.length > 0
            max = l[ 0 ]
        for i in [ 1 ... l.length ]
            val = l[ i ]
            if val > max
                max = val
        return max
        
    _get_min: ( l ) ->
        if l.length > 0
            min = l[ 0 ]
        for i in [ 1 ... l.length ]
            val = l[ i ]
            if val < min
                min = val
        return min