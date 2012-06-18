# straight line strip
class Element_WithIndices extends Element
    constructor: ( indices = [] ) ->
        super()
        
        @add_attr
            indices: indices # point numbers
            
    point_in: ( mesh, points ) ->
        for a in @indices
            for p in points
                if mesh.points[ a.get() ] == p
                    return true
        return false
            
    get_point_numbers: ->
        @indices.get()
