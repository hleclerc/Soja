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
            _repr     : ""
            
        @_buff = new Image
        @_buff.onload = =>
            @_signal_change()
            
        @bind =>
            if @_repr? and @_repr.has_been_modified()
                @_buff.src = @_repr.get()
        
        # default values
        @_name.set "View"
        @_ico.set "img/view-presentation.png"
        
        
    accept_child: ( ch ) ->
        #

    z_index: ->
        1
        
    draw: ( info ) ->
        info.ctx.drawImage @_buff, 0, 0
        
    sub_canvas_items: ->
        [ @background, @axes ]

    #     has_nothing_to_draw: ->
    #         true
