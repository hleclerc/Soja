# Link between TreeData and CanvasManager
class CanvasManagerPanelInstance extends LayoutManagerPanelInstance
    constructor: ( el, @app_data, @view_item, undo_manager ) ->
        super el

        #
        @cm = new CanvasManager
            el   : @div
            cam  : @view_item.cam
            items: @app_data.visible_tree_items[ @view_item.panel_id ]
            time : @app_data.time
            selected_items: @app_data.selected_tree_items
            context_menu  : ( evt, show ) => @_launch_context_menu( evt, show )
            add_transform : ( evt, show ) => @_add_transform_node( evt )
            theme         : @app_data.selected_display_settings().theme

        @cm.click_fun.push ( cm, evt ) =>
            for view in @app_data._views
                if view instanceof TreeApp
                    tree_app = view
            tree_app.data.focus.set @cm.view_id
                    
            if evt.ctrlKey
                @app_data.selected_canvas_pan.toggle @view_item.panel_id
            else
                @app_data.selected_canvas_pan.set [ @view_item.panel_id ]
                
            if @app_data.selected_canvas_pan.contains @view_item.panel_id
                @app_data.last_canvas_pan.set @view_item.panel_id
                
        @cm.dblclick_fun.push ( cm, evt ) =>
            @_add_transform_node( evt )
        #
        bind @app_data.selected_canvas_pan, =>
            @_update_borders()
            
    # called each time panel is resized (including the first size definition)
    render: ( info ) ->
        @el.appendChild @div
        
        @p_min = info.p_min
        @p_max = info.p_max
        @_update_borders()
        
        w = info.p_max[ 0 ] - info.p_min[ 0 ]
        h = info.p_max[ 1 ] - info.p_min[ 1 ]
        @cm.resize w, h
        @cm.draw()
        
    #
    _update_borders: ->        
        s = 1 * @app_data.selected_canvas_pan.contains( @view_item.panel_id )
        
        @div.style.left   = @p_min[ 0 ] - s
        @div.style.top    = @p_min[ 1 ] - s
        @div.style.width  = @p_max[ 0 ] - @p_min[ 0 ]
        @div.style.height = @p_max[ 1 ] - @p_min[ 1 ]
        
        if s
            @div.style.borderWidth = 1
            add_class @div, "SelectedCanvas"
        else
            @div.style.borderWidth = 0
            rem_class @div, "SelectedCanvas"
            
    _launch_context_menu: ( evt, show ) =>
        if show == true
            @_show_context_menu( evt )
        else
            @_delete_context_menu( evt )
            
    _delete_context_menu: ( evt ) =>
        if document.getElementById( "contextMenu" ) != null
            menu = document.getElementById( "contextMenu" )
            parent = document.getElementById( "main_window" )
            parent.removeChild menu
    
    _add_transform_node: ( evt ) =>
        for m in @app_data.modules when m instanceof TreeAppModule_Transform
            m.actions[ 1 ].fun evt, @app_data._views[ 0 ]
    
    _show_context_menu: ( evt ) =>
        @_delete_context_menu()
        
        evt = window.event if not evt?
        # look if there's a movable point under mouse
        for phase in [ 0 ... 2 ]
            movable_entities = @cm._get_movable_entities phase
            if movable_entities.length
                break
                
        point_under = false
        if movable_entities.length > 0
            if movable_entities[ 0 ].type == "Transform"
                point_under = "Transform"
            else
                point_under = "Mesh"
        
        menu_item = []
        
        #firstly list all tree items
        for it in @cm.items
            menu_item.push it._name
            
        #secondly list all actions for the selected items
        for si in @cm.selected_items
            cur = si[ si.length-1 ]
            menu_item.push cur._name
            
        @modules = @app_data.modules
        for m in @modules
            for c in m.actions
                menu_item.push c.txt, c.fun

        parent = document.getElementById( "main_window" )
        @menu = new_dom_element
            parentNode: parent
            id        : "contextMenu"
            style     :
                position: "absolute"
                left    : evt.clientX - 1
                top     : evt.clientY - 65
                
                
        if point_under == "Transform"
            @_show_actions TreeAppModule_Transform
            
        else if point_under == "Mesh"
            @_show_actions TreeAppModule_Sketch
            
        else
            @_show_actions TreeAppModule_PanelManager
                                
        @_show_actions TreeAppModule_UndoManager
        
    _show_actions: ( module ) ->
        for m in @modules
            for c in m.actions when m instanceof module and c.ico?
                do ( c ) =>
                    elem = new_dom_element
                        parentNode: @menu
                        className : "contextMenuElement"
                        onclick   : ( evt ) => 
                            c.fun evt, @app_data._views[0]
                            @_delete_context_menu( evt )
                            
                    new_dom_element
                        parentNode: elem
                        nodeName  : "img"
                        src       : c.ico
                        alt       : ""
                        title     : c.txt
                        height    : 24
                        style     :
                            paddingRight: "2px"
                            
                    new_dom_element
                        parentNode: elem
                        nodeName  : "span"
                        txt       : c.txt
                        style     :
                            position: "relative"
                            top     : "-5px"

