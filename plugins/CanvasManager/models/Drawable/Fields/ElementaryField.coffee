# 
class ElementaryField extends Model
    constructor: ( mesh ) ->
        super()
        
        @add_attr
            _mesh: mesh
            _data: new TypedArray_Float64( mesh?.nb_points?() )
            
    get_drawing_parameters: ( model ) ->
        model.add_attr
            drawing_parameters:
                _legend: new Legend( model.name )
                
        model.mod_attr
            drawing_parameters:
                display_style: new Choice( 0, [ "Points", "Wireframe", "Surface", "Surface with Edges" ] )
                legend       : model.drawing_parameters._legend
    
    
    toString: ->
        @name.get()
    
    get: () ->
        @_data.get()
        
    sub_canvas_items: ->
        if @drawing_parameters?
            [ @drawing_parameters._legend ]
        else
            []
            
    z_index: () ->
        return 140
        
    get_val: ( i ) ->
        @_data.get i
        
    draw: ( info, parameters, additionnal_parameters ) ->
        if parameters?
            @actualise_value_legend parameters._legend
            
            # projection points
            proj = if additionnal_parameters?.warp_by? and @_mesh.points.length == additionnal_parameters.warp_by._vector[ 0 ]?._data[ 0 ]?.field?._data.size()?[ 0 ]
                for p, i in @_mesh.points
                    info.re_2_sc.proj Vec_3.add p.pos.get(), Vec_3.mus( additionnal_parameters.warp_factor, additionnal_parameters.warp_by.get_val( i, 3 ) )
            else
                for p, i in @_mesh.points
                    info.re_2_sc.proj p.pos.get()

            for el in @_mesh._elements
                el._draw_elementary_triangle? info, proj, @_data, parameters.display_style.get(), parameters._legend
                
            # legend
            parameters._legend.draw info
    
    
    
#         if parameters.visualization?
#             for tri, i in triangles
#                 @_draw_elementary_triangle info, parameters, tri.get(), proj, @_data[ i ], legend
    
    actualise_value_legend: ( legend ) ->
        if @_data.has_been_modified() or not legend.is_correct()
            min = @get_min_data()
            legend.min_val.set min
        
            max = @get_max_data()
            legend.max_val.set max
        
    get_min_data: ->
        @_get_min @_data.get()
        
    get_max_data: ->
        @_get_max @_data.get()
        
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
            
    