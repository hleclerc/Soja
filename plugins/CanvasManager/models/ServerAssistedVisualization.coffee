class ServerAssistedVisualization extends Model
    constructor: ( app, bs ) ->
        super()
        
        @add_attr
            data  : app.data
            layout: {}
        
        bs.bind =>
            used_lid = {}
            for mid, lm of app.layouts
                for lid, lay of lm._pan_vs_id when lay.cm?
                    if not @layout[ lid ]?
                        @layout.add_attr lid,
                            width : 0
                            height: 0
                    @layout[ lid ].width .set lay.cm.canvas.width
                    @layout[ lid ].height.set lay.cm.canvas.height
                    used_lid[ lid ] = true
                    
            for d in ( lid for lid in @layout._attribute_names when not used_lid[ lid ]? )
                @layout.rem_attr d
                    
    