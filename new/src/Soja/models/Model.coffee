# dep ../util/ModelIterator.coffee

#
#
# Technically Model are only views on binary data, meaning that most of the created models are "transient" (freed right after creation).
class Model
    # std attributes
    # __orig -> parent object, that contains
    # __id   -> only if orig == this. Id of the model (used by pointers).
    # __data -> only if orig == this. Binary buffer that contains the data
    
    # static arguments
    @__conv_list = [
        ( val ) -> if val instanceof Model then val.constructor
    ]
    
    @__id_map = {}
    @__cur_id = 1
    
    # model.val <-> get()
    Model.prototype.__defineGetter__ "val", ->
        @get()

    # model.val = x <-> set x
    Model.prototype.__defineSetter__ "val", ( v ) ->
        @set v

    #
    get: ( val ) -> 
        res = {}
        for item in @constructor.__type_info.attr
            res[ item.name ] = @[ item.name ].get()
        return res

    #
    set: ( val ) -> 
        # TODO: remove this first case when JS 1.7 will appear :)
        if val instanceof Model
            for item in val.constructor.__type_info.attr
                @[ item.name ]?.set val[ item.name ]
        else
            for n, v of val
                @[ n ]?.set v

    #        
    __iterator__: ->
        new ModelIterator @constructor.__type_info.attr
    
    # allows for conversion from standard javascript objects (e.g. 10, "foo") to Model
    # if val is already a Model, returns val
    @__conv: ( val ) ->
        for f in Model.__conv_list
            res = f val
            if res?
                return res
        console.error "unknown type (#{val.constructor})"

    # if no __type_info, make it, and add getters in prototypes
    @__make___type_info_and_protoype: ( type ) ->
        if not type.__type_info?
            # precomputations
            s = 0
            lst = []
            for n, v of type.attr
                t = Model.__conv v
                Model.__make___type_info_and_protoype t

                lst.push
                    name         : n
                    type         : t
                    offset       : s
                    default_value: v

                do ( n, t, s ) ->
                    type.prototype.__defineGetter__ n, ->
                        res = new t
                        res.__orig = @__orig
                        res.__offset = @__offset + s
                        res
                        
                    type.prototype.__defineSetter__ n, ( val ) ->
                        @[ n ].set val
                
                s += t.__type_info.size
            
            # __type_info
            type.__type_info = 
                size: s
                attr: lst
                name: type.toString().match( ///function\s*(\w+)/// )[ 1 ]

        
# 
mew = ( type, args ) ->
    # complete prototype if necessary
    Model.__make___type_info_and_protoype type

    # new instance
    res = new type
    res.__data   = new ArrayBuffer type.__type_info.size
    res.__orig   = res
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

