
# creates an Model of type $type. Acts like a new
# for each mew (which create room for binary data and register the object in Model.__id_map), del should be called
mew = ( type, args ) ->
    mmew type, 1, args


# multiple
mmew = ( type, size, args ) ->
    # complete prototype if necessary
    Model.__make___type_info_and_protoype type

    # new instance
    res = new type
    res.__data   = new ArrayBuffer size * type.__type_info.size
    res.__orig   = res
    res.__n_attr = 0
    res.__offset = 0
    res.__id     = Model.__cur_id++
    
    # register
    Model.__id_map[ res.__id ] = res
    
    # initialisation
    for item in type.__type_info.attr
        if item.default_value?
            for o in [ 0 ... size ]
                res.__offset = o * type.__type_info.size
                res[ item.name ].set item.default_value
            
    if res.init?
        for o in [ 0 ... size ]
            res.__offset = o * type.__type_info.size
            res.init args
    
    res.__offset = 0
    return res


# delete model
del = ( m ) ->
    delete Model.__id_map[ m.__id ]

 
