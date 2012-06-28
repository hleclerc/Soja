#
#
class TypedArray_Int32 extends TypedArray
    constructor: ( size = [], data ) ->
        super size, data
        
    base_type: ->
        Int32Array

    deep_copy: ->
        new TypedArray_Int32 @_size, @_data
        