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
                _legend: new Legend( "todo" )
                
        model.drawing_parameters.add_attr
            display_style: new Choice( 2, [ "Points", "Wireframe", "Surface", "Surface with Edges" ] )
            gradient     : model.drawing_parameters._legend.gradient
            legend       : model.drawing_parameters._legend
    
    toString: ->
        @name.get()

    draw: ( info, parameters, additionnal_parameters ) ->
        if parameters?
            # projection points

            proj = if additionnal_parameters?.warp_by? and @_mesh.points.length == additionnal_parameters.warp_by._vector[ 0 ]?._data[ 0 ]?.field?._data.size()?[ 0 ]
                for p, i in @_mesh.points
                    info.re_2_sc.proj Vec_3.add p.pos.get(), Vec_3.mus( additionnal_parameters.warp_factor, additionnal_parameters.warp_by.get_val( info, i, 3 ) )
            else
                for p, i in @_mesh.points
                    info.re_2_sc.proj p.pos.get()

            #             @actualise_value_legend parameters._legend
            for el in @_mesh._elements
                el.draw_nodal_field? info, proj, @_data, parameters.display_style.get(), parameters._legend
                
    sub_canvas_items: ->
        console.log @drawing_parameters
        if @drawing_parameters?
            [ @drawing_parameters._legend ]
        else
            []

    z_index: ->
        50
        
    get_val: ( info, i ) ->
        @_data.get i
    
#     actualise_value_legend: ( legend ) ->
#         min = @get_min_data()
#         legend.min_val.set min
#         
#         max = @get_max_data()
#         legend.max_val.set max
#         
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
        