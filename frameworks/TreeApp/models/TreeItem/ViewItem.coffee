#
class ViewItem extends TreeItem
    constructor: ( @app_data, panel_id, cam = new( Cam ) ) ->
        super()
        
        # attributes
        @add_attr
            background: new Background
            cam       : cam
            axes      : new Axes
            _panel_id : panel_id
            
        
        # default values
        @_name.set "View"
        @_ico.set "img/view-presentation.png"
        
        
    accept_child: ( ch ) ->
        #
        
    sub_canvas_items: ->
        [ @background, @axes ]

    has_nothing_to_draw: ->
        true
