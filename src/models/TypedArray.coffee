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
        index = @_get_index index
        if @_data[ index ] != value
            @_data[ index ] = value
            @_signal_change()
        
        
    toString: ->
        m = 1
        res = ""
        l = for s in @_size
            o = m
            m *= s
            o
        for v, i in @_data
            res += v
            for j in [ l.length - 1 .. 0 ]
                if i % l[ j ] == l[ j ] - 1
                    res += [ " ", "\n", "\n\n" ][ j ]
                    break
        return res

    equals: ( obj ) ->
        if obj instanceof TypedArray
            if @_size.length != obj._size.length
                return false
            for v, i in @_size
                if v != obj._size[ i ]
                    return false
            return @_data == obj._data
        return @_data == obj

    get: ( index )->
        if index?
            @_data[ @_get_index index ]
        else
            @_data

    _get_index: ( index ) ->
        if index.length
            o = 0
            m = 1
            for i in [ 0 ... index.length ]
                o += m * index[ i ]
                m *= @_size[ i ]
            return o
        return index

    _get_fs_data: ( out ) ->
        FileSystem.set_server_id_if_necessary out, this
        out.mod += "C #{@_server_id} #{@toString()} "
            
    _get_state: ->
        @_data

    _set_state: ( str, map ) ->
        @set str
        