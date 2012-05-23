# 
class Elementary_Fields extends Model
    constructor: ( name, data = new Lst, params = {} ) ->
        super()
        
        @add_attr
            name            : name
            _data           : data
    
    
    toString: ->
        @name.get()

    dim: ->
        1
        
    add_display_style: ( style ) ->
        @_display_style.push style