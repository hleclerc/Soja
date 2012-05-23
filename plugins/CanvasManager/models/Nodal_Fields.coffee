# 
class Nodal_Fields extends Model
    constructor: ( name, data = new Lst, params = {} ) ->
        super()
        
        @add_attr
            name           : name
            _data          : data
    
    toString: ->
        @name.get()

    dim: ->
        3
        
    add_display_style: ( style ) ->
        @_display_style.push style