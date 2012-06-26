# 
class ImageField extends Drawable
    constructor: ( name, path ) ->
        super()
                
        @add_attr
            name : name         
            visualization:
                img          : new Img path
                legend       : new Legend( name )
            
    
    toString: ->
        @name.get()
        
    draw: ( info, proj ) ->
        if @visualization.img?
            @visualization.img.draw info
        if @visualization.legend?
            @visualization.legend.max_val.set 255
            @visualization.legend.min_val.set 0
            @visualization.legend.draw info
            
    z_index: () ->
        return 50
        