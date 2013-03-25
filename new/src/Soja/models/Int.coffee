# dep Model.coffee
    
#    
class Int extends Model
    @__type_info =
        size: 32
        alig: 32
        attr: []
        name: "Int"
        nsub: 1
        
    Model.__conv_list.push ( val ) ->
        if typeof val == "number" then Int
    
    get: -> 
        view = new Int32Array @__orig.__data, @__offset / 8, 1
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
        Boolean @get()

    # true if ModelEditorInput works for this
    Int::__defineGetter__ "__input_edition", ->
        true
