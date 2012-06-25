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
            el.draw_nodal_field? info, proj, @_data, @visualization.display_style.get(), @visualization.legend

    z_index: () ->
        return 50

    
