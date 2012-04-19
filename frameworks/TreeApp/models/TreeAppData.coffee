#
class TreeAppData extends Model
    constructor: ->
        super()

        @add_attr
            # tree
            tree_items         : new Lst # root items 
            selected_tree_items: new Lst # path list
            visible_tree_items : new Model # for each panel_id
            closed_tree_items  : new Lst
            # canvas
            selected_canvas_pan: new Lst # panel_id of selected panels
            last_canvas_pan    : new Str #
            # routes, ...
            browser_state      : new BrowserState
            # loaded modules
            modules            : new Lst
            focus              : -1
            time               : new ConstrainedVal( 0, { _min: 0, _max: -1, _div: 0 } )
        
#         bind @focus, =>
#             console.log @focus.get()
    
    close_item: ( item ) ->
        @closed_tree_items.push item
        
    open_item: ( item ) ->
        for it, index in @closed_tree_items
            if item.equals it
                @closed_tree_items.splice index, 1        
    
    new_session: ( name ) ->
        s = new SessionItem name, this
        @tree_items.push s
        
        d = new DisplaySettingsItem
            sep_norm: 0
            children: [ {
                panel_id: "MainView"
                strength: 3,
            }, {
                sep_norm: 1
                children: [ {
                    panel_id: "TreeView"
                }, {
                    strength: 2,
                    panel_id: "EditView"
                } ]
            } ]
        s._children.push d

    #
    selected_session: ->
        for session in @tree_items
            if @has_a_selected_child session
                return session
        return @tree_items[ 0 ]

    # return current DisplaySettingsItem
    selected_display_settings: ->
        session = @selected_session()
        session._children.detect ( x ) -> x instanceof DisplaySettingsItem

    #
    panel_id_list: ->
        d = @selected_display_settings()
        d._layout.panel_id_of_term_panels().filter ( x ) -> x not in [ "TreeView", "EditView" ]
    
    # return selected cam
    get_current_cam: ->
        panel_id = @last_canvas_pan.get()
        for i in [0...@selected_display_settings()._children.length]
            if @selected_display_settings()._children[i]._panel_id.get() == panel_id
                return @selected_display_settings()._children[i].cam

    # return true if tree item $item is selected or has a selected child
    has_a_selected_child: ( item ) ->
        if item in @selected_tree_items
            return true
        for c in item._children
            if @has_a_selected_child c
                return true
        return false
    
    # return item selected (not the path)
    get_selected_tree_items: ->
        items = new Lst
        for path in @selected_tree_items
            items.push path[ path.length-1 ]
        return items
    
    get_root_path_in_selected: ( item ) ->
        for path in @selected_tree_items
            for it in path
                if it.model_id == item.model_id
                    return path

    get_root_path: ( item ) ->
        res = []
        path = []
        for root in @tree_items
            path.push root
            if item.equals root
                res.push path.slice(0)
            else
                node = root
                @get_root_path_rec path, item, node, res
            return res
                
    get_root_path_rec: ( path, item, node, res ) ->
        for child in node._children
            if item.equals child
                path.push child
                res.push path.slice(0)
                path.pop()
                return path
                
        for child in node._children
            path.push child
            @get_root_path_rec path, item, child, res
            path.pop()