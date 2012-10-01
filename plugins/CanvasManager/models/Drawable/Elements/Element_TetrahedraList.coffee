# 
class Element_TetrahedraList extends Element
    constructor: ->
        super()
        
        @add_attr
            indices: new TypedArray_Int32 [ 4, 0 ]
            
    draw: ( info, mesh, proj, is_a_sub ) ->
    