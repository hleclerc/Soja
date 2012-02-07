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
                if not img?
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
