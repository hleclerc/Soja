class Model
    # std attributes
    __orig = undefined
    __data = undefined
    
    # static arguments
    @__conv_list = [
        ( val ) -> if val instanceof Model then val.constructor
    ]

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
        console.log "pouet"
        new ModelIterator @constructor.__type_info.attr
    
    # allows for conversion from standard javascript objects (e.g. 10, "foo") to Model
    # if val is already a Model, returns val
    @__conv: ( val ) ->
        for f in Model.__conv_list
            res = f val
            if res?
                return res
        console.error val
        console.error "unknown type"
        
    # for "elementary" initialisation. Only leaf object have an __init method.
    @__init: ( val ) ->


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

                do ( t, s ) ->
                    type.prototype.__defineGetter__ n, ->
                        res = new t
                        res.__orig = @__orig
                        res.__offset = @__offset + s
                        res
                
                s += t.__type_info.size
            
            # __type_info
            type.__type_info = 
                size: s
                attr: lst
                name: type.toString().match( ///function\s*(\w+)/// )[ 1 ]

class ModelIterator
    constructor: ( @attr ) ->
        @current = 0
        console.log @attr.length
        
    next: ->
        if @current >= @attr.length
            throw StopIteration
        @attr[ @current++ ].name

        
# 
mew = ( type, args ) ->
    # complete prototype if necessary
    Model.__make___type_info_and_protoype type

    # new instance
    res = new type
    res.__data   = new ArrayBuffer type.__type_info.size
    res.__orig   = res
    res.__offset = 0
    # initialisation
    for item in type.__type_info.attr
        if item.default_value?
            res[ item.name ].set item.default_value
    res.init? args
    return res



    
    
class Int extends Model
    Model.__conv_list.push ( val ) ->
        if typeof val == "number" then Int
    
    get: -> 
        view = new Int32Array @__orig.__data, @__offset, 1
        view[ 0 ]

    set: ( val ) -> 
        view = new Int32Array @__orig.__data, @__offset, 1
        view[ 0 ] = val
        
    toString: ->
        @get().toString()
        
    toBoolean: ->
        Boolean @get()
        
    @__type_info =
        size: 4
        attr: []
        name: "Int"
        
    @__init: ( data, offset, val ) ->
        Int.__set data, offset, val
    
__Ptr_map = {}
    
Ptr = ( type, args ) ->
    

# extends Model
#     @attr =
#         mode_id: 0
#         offset : 0


class MonSousModel extends Model
    @attr =
        a: 11
        b: 12


class MonModel extends Model
    @attr =
        tata: 100
        toto: mew MonSousModel
        p   : mew Ptr( MonSousModel )
    
    init: ( val ) ->
        @tata.set val

# test_0 = ->
m = mew MonModel, 15
m.toto.set { a: 157 }
console.log m.get()
# console.log Boolean m.tata
# console.log String m.tata
