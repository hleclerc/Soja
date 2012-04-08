class TreeAppModule_ImageSet extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'Image'
        @visible = true # must be set to false after test
        @numpic = 1
        
        @actions.push
            ico: "img/shooting_32.png"
            siz: 1
            txt: "New Shooting"
            fun: ( evt, app ) =>
                #
                @collection = new ShootingItem app
                
                session = app.data.selected_session()
                session._children.push @collection
                @unselect_all_item app
                @select_item app, @collection
                @watch_item app, @collection
                
                app.undo_manager.snapshot()
                
        @actions.push
            ico: "img/add_pic_24.png"
            siz: 1
            txt: "Add Image"
            fun: ( evt, app, img ) =>
                @collection = @add_item_depending_selected_tree app, ImgSetItem
                
                if not img?
#                     tab = [ "explo_dz.png", "explo_in.png", "explo_re.png" ]
#                     console.log @numpic
#                     console.log tab[ @numpic ]
#                     img = new ImgItem tab[ @numpic ], app
                    #                     if @numpic%2 == 1
                    #                         img = new ImgItem "left.png", app
                    #                     else
                    #                         img = new ImgItem "right.png", app
#                     @numpic++
                    img = new ImgItem "composite0"+ @numpic++ +".png", app
                @collection.add_child img
                
                app.data.time._max.set app.data.time._max.get() + 1
                app.data.time._div.set app.data.time._max.get()
                
                #by default, show only the first
                if @collection._children.length == 1
                    app.data.time.set 0
                    
                app.fit()
                app.undo_manager.snapshot()
                
            key: [ "Shift+A" ]

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
