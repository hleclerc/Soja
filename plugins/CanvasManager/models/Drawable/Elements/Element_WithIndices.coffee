# straight line strip
class Element_WithIndices extends Element
    constructor: ( indices = [] ) ->
        super()
        
        @add_attr
            indices: indices # point numbers
            
    points_inside: ( tab_ind ) ->
        for i in tab_ind
            for a in @indices
                if a.equals i
                    return true
        return false
        
    get_point_numbers: ->
        @indices.get()
            
    update_indices: ( done, n_array ) ->
        if not done[ @model_id ]?
            done[ @model_id ] = true
            for v in @indices
                v.set n_array[ v.get() ]
