#
#
class TypedArray_Int32 extends TypedArray
    constructor: ( size = [] ) ->
        tot = size[ 0 ] or 0
        for i in size[ 1 ... ]
            tot *= i
        
        super new Int32Array( tot ), size
        
    base_type: ->
        Int32Array

    deep_copy: ->
        new TypedArray_Int32 @_data, @_size
