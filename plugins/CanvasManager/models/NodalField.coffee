# 
class NodalField extends Drawable
    constructor: ( name, mesh ) ->
        super()
        
        n = mesh?.nb_points?()
        if n?
            n = [ n ]
        
        @add_attr
            name : name
            visualization:
                display_style: new Choice( 0, [ "Points", "Wireframe", "Surface", "Surface with Edges" ] )
                legend       : new Legend( name )
            _mesh: mesh
            _data: new TypedArray_Float64( n )
            
            
    
    toString: ->
        @name.get()

    draw: ( info, proj ) ->
        if not proj?
            proj = for p, i in @_mesh.points
                info.re_2_sc.proj p.pos.get()
        
        for el in @_mesh._elements
            @actualise_value_legend @_data.get()
            el.draw_nodal_field? info, proj, @_data, @visualization.display_style.get(), @visualization.legend

    z_index: () ->
        return 50
        
    
    actualise_value_legend: ( values ) ->
        max = @_get_max values
        @visualization.legend.max_val.set max
        
        min = @_get_min values
        @visualization.legend.min_val.set min
        
        
    _get_max: ( l ) ->
        if l.length > 0
            max = l[ 0 ]
        for i in [ 1 ... l.length]
            val = l[ i ]
            if val > max
                max = val
        return max
        
    _get_min: ( l ) ->
        if l.length > 0
            min = l[ 0 ]
        for i in [ 1 ... l.length]
            val = l[ i ]
            if val < min
                min = val
        return min