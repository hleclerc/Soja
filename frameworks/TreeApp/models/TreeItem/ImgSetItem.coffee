#
class ImgSetItem extends TreeItem
    constructor: ( @app_data, @panel_id ) ->
        super()
        
        @_name.set "Image collection"
        @_ico.set "img/krita_16.png"
        @_viewable.set true
        
    accept_child: ( ch ) ->
        ch instanceof ImgItem

    draw: ( info ) ->
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
        