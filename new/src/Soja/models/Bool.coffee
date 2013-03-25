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
        Boolean view[ 0 ] & ( 1 << ( @__offset % 8 ) )

    __set: ( val ) -> 
        if typeof val != "boolean" 
            @__set val.get()
        else
            view = new Int8Array @__orig.__data, @__offset / 8, 1
            mask = 1 << ( @__offset % 8 )
            old = Boolean view[ 0 ] & mask
            if old != val
                if val
                    view[ 0 ] |= mask
                else
                    view[ 0 ] &= ~mask
                true
            else
                false
        
    toString: ->
        @get().toString()
        
    toBoolean: ->
        @get()

