class SessionItem extends TreeItem
    constructor: ( name ) ->
        super()
        
        @_name._set name
        @_ico._set "img/document-open.png"
        

        bind this, =>
            max = 0
            for ch in this._children
                m = ch.anim_min_max()
                if m > max
                    max = m
            # TODO get access to app data from constructor or something else
            if app.data?
                app.data.time.max.set max - 1
                app.data.time.div.set max - 1
            
    accept_child: ( ch ) ->
        true
        
    