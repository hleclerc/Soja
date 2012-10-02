#
class ImgSetItem extends TreeItem
    constructor: ->
        super()
        
        @_name.set "Image collection"
        @_ico.set "img/krita_16.png"
        @_viewable.set true
        
    accept_child: ( ch ) ->
        ch instanceof ImgItem or
        ch instanceof RawVolume

    draw: ( info ) ->
        # TODO: use min max for that
        if info.time_ref._max? and info.time_ref._max.get() < @_children.length - 1
            info.time_ref._max.set @_children.length - 1
        if info.time_ref?
            info.time_ref._div.set Math.max info.time_ref._max.get(), 1
            
        #
        if @_children[ info.time ]?
            @_children[ info.time ].draw info
        else if @_children[ 0 ]?
            @_children[ 0 ].draw info
    
    z_index: ->
        if @_children.length
            return @_children[ 0 ].z_index()
        return 0
    
    update_min_max: ( x_min, x_max ) =>
        if @_children[ 0 ]?
            @_children[ 0 ].update_min_max x_min, x_max

    anim_min_max: ->
        return @_children.length
        