
# creates an Model of type $type. Acts like a new
# for each mew (which create room for binary data and register the object in Model.__id_map), del should be called
mew = ( type, args ) ->
    mmew type, 1, args


# multiple
# optionnal args :
#  array_buffer Araybuffer to has to be used
#  default_value: 
#  beg_init
mmew = ( type, size, args = {} ) ->
    # complete prototype if necessary
    Model.__make___type_info_and_protoype type

    # new instance
    res = new type
    if args.array_buffer?
        res.__data   = args.array_buffer
    else
        res.__data   = new ArrayBuffer size * type.__type_info.size
    res.__orig   = res
    res.__n_attr = 0
    res.__offset = 0
    res.__id     = Model.__cur_id++
    
    # register
    Model.__id_map[ res.__id ] = res
    
    # initialisation
    if not args.array_buffer? or args.beg_init?
        beg_init = args.beg_init or 0
        if beg_init < size
            for item in type.__type_info.attr
                if item.default_value?
                    for o in [ beg_init ... size ]
                        res.__offset = o * type.__type_info.size
                        res[ item.name ].set item.default_value
                    
            if res.init?
                for o in [ beg_init ... size ]
                    res.__offset = o * type.__type_info.size
                    res.init args.default_value
            else if args.default_value?
                for o in [ beg_init ... size ]
                    res.__offset = o * type.__type_info.size
                    res.set args.default_value
    
    res.__offset = 0
    return res


# delete model
del = ( m ) ->
    if m?
        if m.__id? and m.__id
            delete Model.__id_map[ m.__id ]
        else
            console.log "Delete works only with __orig objects (to delete an object from a pointer, use del ptr.obj)"
 
# basic clien : copy attributes
__clone = ( obj, c = {} ) ->
    res = new obj.constructor
    for n, v of obj
        res[ n ] = v
    for n, v of c
        res[ n ] = v
    res
    
# slice dies not appear to be available on all interpreter
if not ArrayBuffer.prototype.slice
    ArrayBuffer.prototype.slice = ( start, end ) ->
        that = new Uint8Array this
        if not end?
            end = that.length
        result = new ArrayBuffer end - start
        resultArray = new Uint8Array result
        for i in [ 0 ... resultArray.length ]
            resultArray[ i ] = that[ i + start ]
        return result
