        
# 
mew = ( type, args ) ->
    # complete prototype if necessary
    Model.__make___type_info_and_protoype type

    # new instance
    res = new type
    res.__data   = new ArrayBuffer type.__type_info.size
    res.__orig   = res
    res.__n_attr  = 0
    res.__offset = 0
    res.__id     = Model.__cur_id++
    
    # register
    Model.__id_map[ res.__id ] = res
    
    # initialisation
    for item in type.__type_info.attr
        if item.default_value?
            res[ item.name ].set item.default_value
    res.init? args
    
    return res

# delete model
del = ( m ) ->
    delete Model.__id_map[ m.__id ]

 
