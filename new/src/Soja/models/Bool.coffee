# dep Model.coffee
    
#    
class Bool extends Model
    @__type_info =
        size: 1
        alig: 1
        attr: []
        name: "Bool"
        nsub: 1
        
    Model.__conv_list.push ( val ) ->
        if typeof val == "boolean" then Bool
    
    get: -> 
        view = new Int8Array @__orig.__data, @__offset / 8, 1
        view[ 0 ]

    __set: ( val ) -> 
        if val instanceof Model
            @__set val.get()
        else
            view = new Int32Array @__orig.__data, @__offset / 8, 1
            if typeof val == "number"
                @__set_view view, val
            else
                @__set_view view, Number val
        
    toString: ->
        @get().toString()
        
    toBoolean: ->
        @get()

