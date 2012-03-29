#
class TreeAppModule_TreeView extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'Tree View'
        @visible = false
        
        _ina = ( app ) =>
            app.data.focus.get() != app.treeview.view_id
        
        _ina_cm = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.view_id and 
            app.data.focus.get() != app.treeview.view_id
            
        @actions.push
            txt: "Delete current tree item"
            key: [ "Del" ]
            ina: _ina
            fun: ( evt, app ) =>
                for path in app.data.selected_tree_items
                    #prevent deleting root item (session)
                    if path.length > 1
                        m = path[ path.length - 1 ]
                        if m instanceof ViewItem
                            modules = app.data.modules
                            for mod in modules 
                                if mod instanceof TreeAppModule_PanelManager
                                    mod.actions[ 4 ].fun evt, app
                        else
                            path[ path.length - 2 ].rem_child m
                            @delete_from_tree app, m
                        
                        
        lst_equals = ( a, b ) ->
            if a.length != b.length
                return false
            for va, ia in a
                if va != b[ ia ]
                    return false
            return true
                
        up_down_fun = ( evt, app, inc ) ->
            items = app.data.selected_tree_items
            session = app.data.selected_session()
            if items.length == 0
                app.data.selected_tree_items.clear()
                app.data.selected_tree_items.push [ session ]
            else if items.length == 1
                #first search position of current selected item
                flat = app.layouts[ session.model_id ]._pan_vs_id.TreeView.treeview.flat
                for f, i in flat
                    if i + inc >= 0 and i + inc < flat.length and lst_equals( items[ 0 ], f.item_path )
                        app.data.selected_tree_items.clear()
                        app.data.selected_tree_items.push flat[ i + inc ].item_path
                        break
    
        @actions.push
            txt: ""
            key: [ "UpArrow" ]
            ina: _ina_cm
            fun: ( evt, app ) =>
                up_down_fun evt, app, -1         

        @actions.push
            txt: ""
            key: [ "DownArrow" ]
            ina: _ina_cm
            fun: ( evt, app ) =>
                up_down_fun evt, app, 1

        @actions.push
            txt: ""
            key: [ "LeftArrow" ]
            ina: _ina_cm
            fun: ( evt, app ) =>
                # Close selected items
                items = app.data.selected_tree_items
                for item in items
                    close = @is_close app, item
                    if item[ item.length - 1 ]._children.length > 0 and close == false
                        @add_item_to_close_tree app, item
                            
        @actions.push
            txt: ""
            key: [ "RightArrow" ]
            ina: _ina_cm
            fun: ( evt, app ) =>
                # Open selected items
                items = app.data.selected_tree_items
                for item in items
                    close = @is_close app, item
                    if item[ item.length - 1 ]._children.length > 0 and close == true
                        @rem_item_to_close_tree app, item
                    
        @actions.push
            txt: ""
            key: [ "Enter" ]
            ina: _ina_cm
            fun: ( evt, app ) =>
                # Show/hide items
                path_items = app.data.selected_tree_items
                for path_item in path_items
                    item = path_item[ path_item.length - 1]
                    if item._viewable?.get() == 1
                        for p in app.data.panel_id_list()
                            app.data.visible_tree_items[ p ].toggle item
                        
    delete_from_tree: ( app,  item ) =>
        #delete children
        for c in item._children
            if c._children.length > 0
                @delete_from_tree app, c
            app.data.closed_tree_items.remove c
            for p in app.data.panel_id_list()
                app.data.visible_tree_items[ p ].remove c
        
        #delete item
        app.data.closed_tree_items.remove item
        for p in app.data.panel_id_list()
            app.data.visible_tree_items[ p ].remove item
        app.data.selected_tree_items.clear()
        
    is_close: ( app, item ) ->
        for closed_item_path in app.data.closed_tree_items
            if item.equals closed_item_path
                return true
        return false
    
    add_item_to_close_tree: ( app, item ) ->
        app.data.closed_tree_items.push item
        
    rem_item_to_close_tree: ( app, item ) ->
        ind = app.data.closed_tree_items.indexOf item
        app.data.closed_tree_items.splice ind, 1