#
#
class TypedArray_Float64 extends TypedArray
    constructor: ( size = [] ) ->
        tot = size[ 0 ] or 0
        for i in size[ 1 ... ]
            tot *= i
        
        super new Float64Array( tot ), size
        
    base_type: ->
        Float64Array

    deep_copy: ->
        new TypedArray_Float64 @_data, @_size

    _set: ( value ) ->
        if @_data != value
            @_data = new Float64Array value
            return true
        return false
    