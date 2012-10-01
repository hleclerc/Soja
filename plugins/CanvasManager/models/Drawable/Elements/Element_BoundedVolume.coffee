# 
class Element_BoundedVolume extends Element
    constructor: ( boundaries = [] ) ->
        super()
        
        @add_attr
            boundaries: boundaries   # list of { e: element ref, o: orientation }
        
    draw: ( info, mesh, proj, is_a_sub ) ->
            
    update_indices: ( done, n_array ) ->
        for b in @boundaries
            b.e.update_indices? done, n_array

    closest_point_closer_than: ( best, mesh, proj, info, pos ) ->
        undefined

    add_sub_element: ( res ) ->
        for b in @boundaries
            if b.e not in res
                res.push b.e
                