# dep Model.coffee

# 32 bits
class Char extends Model
    @__type_info =
        size: 4
        attr: []
        name: "Char"
        nsub: 1
    
    get: -> 
        view = new Int32Array @__orig.__data, @__offset, 1
        String.fromCharCode( view[ 0 ] )

    set: ( val ) -> 
        view = new Int32Array @__orig.__data, @__offset, 1
        if typeof val == "number"
            view[ 0 ] = val
        else
            if typeof val != "string"
                val = String val
            view[ 0 ] = val.charCodeAt 0 
        
    toString: ->
        @get()
        
    toBoolean: ->
        Boolean @get()
        
