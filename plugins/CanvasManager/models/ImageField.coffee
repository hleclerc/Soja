# 
class ImageField extends Drawable
    constructor: ( name, path ) ->
        super()
                
        @add_attr
            name : name         
            img  : new Img path
            visualization:
                legend       : new Legend( name )
            
    
    toString: ->
        @name.get()
        
    draw: ( info, proj ) ->
        if @img?
            @img.draw info
        if @visualization.legend?
            @visualization.legend.max_val.set 255
            @visualization.legend.min_val.set 0
            @visualization.legend.draw info
            
    z_index: () ->
        return 50
        