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

    __set: ( val ) -> 
        view = new Int32Array @__orig.__data, @__offset, 1
        if typeof val == "number"
            @__set_view view, val
        else
            if typeof val != "string"
                val = String val
            @__set_view view, val.charCodeAt( 0 ) 
        
    toString: ->
        @get()
        
    toBoolean: ->
        Boolean @get()
        
