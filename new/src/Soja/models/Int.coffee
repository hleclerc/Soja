# dep Model.coffee
    
#    
class Int extends Model
    @__type_info =
        size: 4
        attr: []
        name: "Int"
        nsub: 1
        
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
