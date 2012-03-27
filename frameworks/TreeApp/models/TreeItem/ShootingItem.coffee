# link cam and picture
class ShootingItem extends TreeItem
    constructor: ( @app, @panel_id ) ->
        super()
        
        # attributes
        
                
        lst_view = new Lst
            
        @add_attr
            view : new Choice( 0, lst_view )
            cam  : new Cam
            #
        
        for el in @app.treeview.flat
            if el.item instanceof DisplaySettingsItem
                bind el.item, =>
                    @view.lst.clear()
                    for el in @app.treeview.flat
                        if el.item instanceof ViewItem
                            @view.lst.push @view.lst.length
        
        bind @view, =>
            i = 0
            for el in @app.treeview.flat
                if el.item instanceof ViewItem
                    console.log @view.get()
                    if i == @view.get()
                        new_cam = el.cam
#                         @mod_attr @cam, new_cam
                    i++
            
        
        # default values
        @_name.set "Shooting informations"
        @_ico.set "img/shooting_16.png"
        @_viewable.set true
        
#         @add_child new ViewItem app_data, panel_id
        @add_child new ImgSetItem

        
    accept_child: ( ch ) ->
        ch instanceof ImgItem or
        ch instanceof ImgSetItem or
        ch instanceof TransformItem
        
#     sub_canvas_items: ->
#         [  ]

    z_index: ->
        0.1
        
    draw: ( info ) ->
        info.shoot_cam = @cam
        for c in @_children
            c.draw info
        delete info.shoot_cam