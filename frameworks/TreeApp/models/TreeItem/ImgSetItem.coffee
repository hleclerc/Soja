#
class ImgSetItem extends TreeItem
    constructor: ( @app_data, @panel_id ) ->
        super()
        
        # default values
        @_name.set "Image collection"
        @_ico.set "img/krita_16.png"
        @_viewable.set true
        
        
        # attributes
#         @add_attr
#             img_collection: new Lst
#             import_picture: new Browse
        
    accept_child: ( ch ) ->
        ch instanceof ImgItem

    draw: ( info ) ->
        if @_children[ info.time ]?
            @_name.set "Image collection (" + @_children[ info.time ]._name.get() + ")"
            @_children[ info.time ].draw info
            
        else if @_children[ 0 ]?
            @_name.set "Image collection (" + @_children[ 0 ]._name.get() + ")"
            @_children[ 0 ].draw info
            
        else
            @_name.set "Image collection (empty)"
    
    z_index: ->
        if @_children.length > 0
            return @_children[ 0 ].z_index()
        else
            return 0
    
    update_min_max: ( x_min, x_max ) =>
        if @_children[ 0 ]?
            @_children[ 0 ].update_min_max( x_min, x_max )

    anim_min_max: ->
        return @_children.length