# dep Model.coffee

class Char extends Model
    @__type_info =
        size: 1
        attr: []
        name: "Char"
        nsub: 1
    
    get: -> 
        view = new Int8Array @__orig.__data, @__offset, 1
        String.fromCharCode( view[ 0 ] )

    set: ( val ) -> 
        view = new Int8Array @__orig.__data, @__offset, 1
        view[ 0 ] = val.charCodeAt 0 
        
    toString: ->
        @get()
        
    toBoolean: ->
        Boolean @get()
        
