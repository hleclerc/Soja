# straight line strip
class Element_WithIndices extends Element
    constructor: ( indices = [] ) ->
        super()
        
        @add_attr
            indices: indices # point numbers
            
    points_in: ( mesh, points ) ->
        for a in @indices
            for p in points
                if mesh.points[ a.get() ] == p
                    return true
        return false
        
    point_in: ( mesh, point ) ->
        for a in @indices
            if mesh.points[ a.get() ] == point
                return true
        return false
        
    get_point_numbers: ->
        @indices.get()
