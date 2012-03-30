#
class Theme extends Model
    constructor: ( name = "original" ) ->
        super()
        
        # new attributes
        @add_attr
            name           : name
            line           : new Color 255, 255, 255, 255
            constrain_line : new Color 122,   0,   0, 255
            free_line      : new Color   0, 122,   0, 255
            dot            : new Color   0, 255,   0, 255
            selected_dot   : new Color 255,   0,   0, 255
            gradient_legend: new Gradient
            anim_delay     : 300
            
        @gradient_legend.add_color [ 255,255,255, 255 ], 0
        @gradient_legend.add_color [   0,  0,  0, 255 ], 1