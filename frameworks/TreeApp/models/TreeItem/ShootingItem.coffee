# link cam and picture
class ShootingItem extends TreeItem
    constructor: ( @app_data, @panel_id ) ->
        super()
        
        # attributes
        @add_attr
            #
        
        # default values
        @_name.set "Shooting informations"
        @_ico.set "img/shooting_16.png"
        
#         @add_child new ViewItem app_data, panel_id
        @add_child new ImgSetItem
                
    accept_child: ( ch ) ->
        ch instanceof ImgItem or
        ch instanceof ImgSetItem or
        ch instanceof ViewItem or
        ch instanceof TransformItem
        

    z_index: ->
        #
