# 
class Elementary_Fields extends Model
    constructor: ( data = new Lst, params = {} ) ->
        super()
        
        @add_attr
            name            : "Elementary fields"
            _data           : data
            _display_style  : new Lst
            _warp_by        : [ "none" ]
            _warp_factor    : 1
    
    add_display_style: ( style ) ->
        @_display_style.push style