#
#
class TypedArray_Float64 extends TypedArray
    constructor: ( size = [], data ) ->
        super size, data
        
    base_type: ->
        Float64Array

    deep_copy: ->
        new TypedArray_Float64 @_size, @_data
    