# 
class ImageField extends Drawable
    constructor: ( name, path ) ->
        super()
                
        @add_attr
            name : name         
            src  : ""
            
        @rgba = new Image
        @rgba.onload = =>
            @_signal_change()
            
        @src.bind =>
            if @src.length
                @rgba.src = @src.get()

    get_drawing_parameters: ( model ) ->
        model.add_attr
            drawing_parameters:
                _legend: new Legend( "todo" )
                
        model.drawing_parameters.add_attr
            gradient     : model.drawing_parameters._legend.gradient
    
    get_min_data: ->
        0
        
    get_max_data: ->
        255
        
    
    toString: ->
        @name.get()
        
    draw: ( info ) ->
        if @rgba.height
            Img._draw_persp_rec info, @rgba, 0, 0, [ 0, @rgba.height, 0 ], [ 1, 0, 0 ], [ 0, -1, 0 ], [ 0, 0, 1 ]
            
    z_index: () ->
        return 50
        