#
class Theme extends Model
    constructor: ->
        super()
        
        @add_attr
            lines             : new LineTheme( new Color( 255, 255, 255, 255 ), 1 )
            points            : new PointTheme( new Color( 0, 255, 0, 255 ), 4, new Color( 255, 255, 255, 255 ), 1 )
            surfaces          : new SurfaceTheme( new Color( 150, 150, 150, 255 ) )
            
            selected_points   : new PointTheme( new Color( 255,   0,   0, 255 ), 4, new Color( 255, 255, 255, 255 ), 1 )
            highlighted_points: new PointTheme( new Color(   0,   0,   0,   0 ), 5, new Color( 255, 255,   0, 255 ), 1 )
            
            anim_delay        : 300
            zoom_factor       : 5
            
            #             line_color                      : new Color 255, 255, 255, 255
            #             line_width                      : 1
            #             constrain_boundary_displacement : new Color 122,   0,   0, 255
            #             constrain_boundary_strain       : new Color 200, 100, 100, 255
            #             constrain_boundary_pressure     : new Color  50,   0,   0, 255
            #             free_boundary                   : new Color   0, 122,   0, 255
            #             dot_color                       : new Color   0, 255,   0, 255
            #             selected_dot_color              : new Color 255,   0,   0, 255
            #             pre_selected_dot_color          : new Color 255,   0,   0, 255
            #             pre_selected_dot_line_width     : 1.5
            gradient_legend  : new Gradient
            
        @gradient_legend.add_color [ 255,255,255, 255 ], 0
        @gradient_legend.add_color [   0,  0,  0, 255 ], 1