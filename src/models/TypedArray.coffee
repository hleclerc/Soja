# Used by TypedArray_...
#
class TypedArray extends Model
    constructor: ( data, size ) ->
        super()
        
        @_data = data
        @_size = size

    base_type: ->
        # -> to be defined by children

    set_val: ( index, value ) ->
        if index.length
            o = 0
            m = 1
            for i in [ 0 ... index.length ]
                o += m * index[ i ]
                m *= @_size[ i ]
            index = o
        console.log "ind", index
        @_data[ index ] = value
        
    toString: ->
        
        @_data?.toString()

    equals: ( obj ) ->
        if obj instanceof TypedArray
            if @_size.length != obj._size.length
                return false
            for v, i in @_size
                if v != obj._size[ i ]
                    return false
            return @_data == obj._data
        return @_data == obj

    get: ( val )->
        if val?
            @_data[ val ]
        else
            @_data

    _get_fs_data: ( out ) ->
        FileSystem.set_server_id_if_necessary out, this
        out.mod += "C #{@_server_id} #{@toString()} "
            
    _get_state: ->
        @_data

    _set_state: ( str, map ) ->
        @set str
        