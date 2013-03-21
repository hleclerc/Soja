#
class Model
    # std attributes
    # __orig = undefined
    # __data = undefined
    # __id   = 0
    
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

#
class ModelIterator
    constructor: ( @attr ) ->
        @current = 0
        
    next: ->
        if @current >= @attr.length
            throw StopIteration
        @attr[ @current++ ].name


    
    
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
    
    
__ptr_type_map = {}
    
Ptr = ( type, args ) ->
    Model.__make___type_info_and_protoype type
    n = type.__type_info.name
    if not __ptr_type_map[ n ]?
        class Loc extends Model
            @attr =
                model_id: 0
                offset  : 0
            @type = type
            
            ref: ( obj ) ->
                if obj not instanceof Loc.type
                    console.error "Bad ptr"
                @model_id.set obj.__orig.__id
                @offset.set obj.__offset
                
            Model.prototype.__defineGetter__ "obj", ->
                Model.__id_map[ @model_id.val ]
            
        __ptr_type_map[ n ] = Loc
        
    __ptr_type_map[ n ]



# extends Model
#     @attr =


class MonSousModel extends Model
    @attr =
        a: 11
        b: 12


class MonModel extends Model
    @attr =
        tata: 100
        p   : mew Ptr( MonSousModel )
#         toto: mew MonSousModel
    
    init: ( val ) ->
        @tata.set val

# test_0 = ->
s = mew MonSousModel
m = mew MonModel, 15
# m.toto.set { a: 157 }
m.p.ref s
console.log m.val
console.log m.p.obj.val
# console.log Boolean m.tata
# console.log String m.tata
