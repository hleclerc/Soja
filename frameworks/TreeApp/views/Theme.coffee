#
class Theme extends Model
    constructor: ( name = "original" ) ->
        super()
        
        # new attributes
        @add_attr
            name          : name
            line          : new Color 255, 255, 255, 255
            dot           : new Color   0, 255,   0, 255
            selected_dot  : new Color 255,   0,   0, 255
            
            