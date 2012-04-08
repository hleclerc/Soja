class SessionItem extends TreeItem
    constructor: ( name, app_data ) ->
        super()
        
        @_name._set name
        @_ico._set "img/document-open.png"
        

        bind this, =>
            max = 0
            for ch in this._children
                m = ch.anim_min_max()
                if m > max
                    max = m
                    
            if app_data?
                app_data.time._max.set max - 1
                app_data.time._div.set max - 1
            
    accept_child: ( ch ) ->
        true
        
    