class TreeAppModule extends Model
    constructor: ->
        super()
        
        @name = ''
        @actions = []

    select_item: ( app, item, parent ) ->
        if !parent
            path = []
            path.push app.data.selected_session()
        else
            path = app.data.get_root_path_in_selected parent
        path.push item
        @unselect_all_item app
        app.data.selected_tree_items.push path

    unselect_all_item: ( app ) ->
        app.data.selected_tree_items.clear()

    watch_item: ( app, item ) ->
        for p in app.data.panel_id_list()
            app.data.visible_tree_items[ p ].push item

        
    get_display_settings_item: ( app ) ->
        for child in app.data.tree_items[ 0 ]._children
            if child instanceof DisplaySettingsItem
                return child


#     #search for typeItem in selected_tree return item if find
#     is_item_in_selected_tree: ( app, typeItem ) ->
#         items = app.data.get_selected_tree_items()
#         for it in items
#             if it instanceof typeItem
#                 return it
#                 
#         return false
    
    
    # this function is used to create item on the right tree place
    # type represent the type of item you want to use
    add_item_depending_selected_tree: ( app, typeItem ) ->
        items = app.data.get_selected_tree_items()
        #search for typeItem in tree
        find_object = false
        for it in items
            if it instanceof typeItem
                object = it
#                 console.log '1'
                find_object = true
        
        #search if typeItem can be a child of the selected item in tree
        if find_object == false
            for it in items
                item = new typeItem
                if it.accept_child()? and it.accept_child item
                    # If he already have a typeItem child
                    for child_item in it._children
                        if child_item instanceof typeItem
                            object = child_item
                            @select_item app, object, it
#                             console.log '2'
                            find_object = true
                            
                    # Else create a child
                    if find_object == false
                        object = item
                        it.add_child object
                        
                        @select_item app, object, it
                        @watch_item app, object
                        
#                         app.undo_manager.snapshot()
#                         console.log '3'
                        find_object = true

        
        #If selection didn't help to find a typeItem child
        if find_object == false
            object = new typeItem
            session = app.data.selected_session()
            session.add_child object
            
            @select_item app, object
            @watch_item app, object
#             console.log '4'
#             app.undo_manager.snapshot()
            
        return object
        
                                
    #type represent the type of current item
    child_in_selected: ( app, typeItem, sel_item ) ->
        current = new typeItem
    
        for it in sel_item
            if current.accept_child it
                app.data.selected_tree_items[ 0 ][ app.data.selected_tree_items[ 0 ].length - 2 ].rem_child it
                @transf.add_child it
                id = it.model_id
                for p in app.data.panel_id_list()
                    for c, i in app.data.visible_tree_items[ p ]
                        if c.model_id == id
                            app.data.visible_tree_items[ p ].splice i, 1
                            break

    add_action: ( act ) ->
        @actions.push act
        act.sub = []
        
        act.add_sub_action = ( n_act ) ->
            act.sub.push n_act
            n_act
            
        return act
        
        