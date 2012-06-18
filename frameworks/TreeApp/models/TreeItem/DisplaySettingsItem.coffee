#
class DisplaySettingsItem extends TreeItem
    constructor: ( layout_manager_data = {} ) ->
        super()

        # new attributes
        @add_attr
            theme: new Theme
            
            _layout: new LayoutManagerData layout_manager_data
            
            
        # default values
        @_name._set "Display settings"
        @_ico._set "img/view-multiple-objects.png"

        # watcher to see if some view_items has to be destroyed
        @_layout.bind =>
            l = @_layout.panel_id_of_term_panels()
            for view_item in @_children when view_item instanceof ViewItem
                if view_item._panel_id.get() not in l
                    @rem_child view_item

        @_layout.allow_destruction = ( data ) =>
            @_layout.panel_id_of_term_panels().length >= 4
            
            
    accept_child: ( ch ) ->
        ch instanceof ViewItem
        
    z_index: ->
        # do nothing
        
        

        

        
