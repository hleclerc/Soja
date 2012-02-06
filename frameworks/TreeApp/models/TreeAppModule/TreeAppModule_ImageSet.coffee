class TreeAppModule_ImageSet extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'Image'
        @numpic = 1
        
        @actions.push
            ico: "img/krita_24.png"
            siz: 1
            txt: "New Collection"
            fun: ( evt, app ) =>
                #
                @collection = new ImgSetItem
                
                session = app.data.selected_session()
                session._children.push @collection
                
                @unselect_all_item app
                @select_item app, @collection
                app.undo_manager.snapshot()

        @actions.push
            ico: "img/add_pic_24.png"
            siz: 1
            txt: "Add Image"
            fun: ( evt, app, img ) =>
                @collection = @add_item_depending_selected_tree app, ImgSetItem
                app.fit()
                if not img?
                    img = new ImgItem "composite0"+ @numpic++ +".png", app
                @collection.add_child img
#                 @collection._children.push img
                anim_module = @get_animation_module app
                anim_time = anim_module.get_anim_time()
                anim_time._max.set anim_time._max.get() + 1
                anim_time._div.set anim_time._max.get()
                
#                 ds = @get_display_settings_item app
#                 ds.anim_time._max.set ds.anim_time._max.get() + 1
#                 ds.anim_time._div.set ds.anim_time._max.get()

                #by default, show only the first
                if @collection._children.length == 1
#                     ds.anim_time.set 0
                    anim_time.set 0
                app.undo_manager.snapshot()
                
            key: [ "Shift+A" ]
