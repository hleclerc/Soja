# Used by TypedArray_...
#
class TypedArray extends Model
    constructor: ( data, size ) ->
        super()
        
        @_data = data
        @_size = size

    base_type: ->
        # -> to be defined by children

    dim: ->
        @_size.length

    size: ( d ) ->
        if d?
            @_size[ d ]
        else
            @_size
        
    set_val: ( index, value ) ->
        index = @_get_index index
        if @_data[ index ] != value
            @_data[ index ] = value
            @_signal_change()
        
    nb_items: ->
        tot = @_size[ 0 ] or 0
        for i in @_size[ 1 ... ]
            tot *= i
        tot
        
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
        out.mod += "C #{@_server_id} #{@_get_state()} "
            
    _get_state: ->
        res = ""
        res += @_size.length
        for s in @_size
            res += "," + s
        for d in @_data
            res += "," + d
        return res

    _set_state: ( str, map ) ->
        l = str.split ","
        s = parseInt l[ 0 ]
        @_size = for v in [ 0 ... s ]
            parseInt l[ v + 1 ]
        
        B = @base_type()
        n = @nb_items()
        @_data = new B n
        for v in [ 0 ... n ]
            @_data[ v ] = parseFloat l[ s + 1 + v ]
            
            