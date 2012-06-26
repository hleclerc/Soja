class SessionItem extends TreeItem
    constructor: ( name, app_data ) ->
        super()

        @add_attr
            _selected_tree_items: new Lst # path list
            _visible_tree_items : new Model # panel_id: [ model_1, ... ]
            _closed_tree_items  : new Lst
            # canvas
            _selected_canvas_pan: new Lst # panel_id of selected panels
            _last_canvas_pan    : new Str #
            _modules            : new Lst
            time                : app_data?.time or new ConstrainedVal( 0, { _min: 0, _max: -1, _div: 0 } )
        
        
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
        