# Tree application
class TreeApp extends View
    constructor: ( @el, @data = new TreeAppData ) ->
        super @data
        
        @layouts = {}
        @cur_session_model_id = -1
        
        @active_key = new Bool true
        
        @undo_manager = new UndoManager @data.tree_items
        header = document.getElementById('correli_header')
        @icobar = new IcoBar header, this
        
        document.addEventListener "keydown", ( ( evt ) => @_on_key_down evt ), true
        
        @selected_view = ""
        

    onchange: ->
        # update layout if current session has changed
        if @data.selected_tree_items.has_been_modified()
            session = @data.selected_session()
            if session?
                if not @layouts[ session.model_id ]?
                    @layouts[ session.model_id ] = @_new_LayoutManager session
                if @cur_session_model_id != session.model_id
                    @layouts[ @cur_session_model_id ]?.hide()
                    @layouts[ session.model_id ].show()
                    @cur_session_model_id = session.model_id

    # return selected CanvasManagerPanelInstance from current session
    selected_canvas_inst: ->
        session = @data.selected_session()
        layout = @layouts[ session.model_id ]
        for panel_id in @data.selected_canvas_pan when layout._pan_vs_id[ panel_id ]?
            layout._pan_vs_id[ panel_id ]

    fit: ( anim = 1 ) ->
        for inst in @selected_canvas_inst()
            inst.cm.fit anim

    # 
    _new_LayoutManager: ( session ) ->
        display_settings = session._children.detect ( x ) -> x instanceof DisplaySettingsItem
        res = new LayoutManager @el, display_settings._layout, @data.browser_state
        res.disp_top = @icobar.disp_top + @icobar.height
        res.new_panel_instance = ( data ) => @_new_panel_instance display_settings, data
        return res
        
    # function that creates a new panel instance.
    _new_panel_instance: ( display_settings, data ) ->
        if data.panel_id == "TreeView"
            res = new LayoutManagerPanelInstance @el
            res.div.className = "PanelInstanceTreeView"        
            res.div.addEventListener "click", ( ( evt ) => @selected_view = data.panel_id )
            res.treeview = new TreeView res.div, @data.tree_items, @data.selected_tree_items, @data.visible_tree_items, @data.closed_tree_items, @data.last_canvas_pan            
            return res
            
        if data.panel_id == "EditView"
            res = new LayoutManagerPanelInstance @el
            res.div.className = "PanelInstanceEditView"
            res.div.addEventListener "click", ( ( evt ) => @selected_view = data.panel_id )
            new EditView res.div, @data, @undo_manager            
            return res
    
        # else, -> canvas manager
        # add a ViewItem to display_settings
        view_item = new ViewItem @data, data.panel_id
        display_settings._children.push view_item
        
        # 
        @data.visible_tree_items.add_attr data.panel_id, new Lst [ view_item ]
        for cm_inst in @selected_canvas_inst()
            for tree_item in @data.visible_tree_items[ cm_inst.view_item.panel_id ]
                if not ( tree_item instanceof ViewItem )
                    @data.visible_tree_items[ data.panel_id ].push tree_item
            view_item.cam.set cm_inst.cm.cam.get()
            break
        
        # add a CanvasManager
        # @model.tree.visibility_context.set data.panel_id
        @data.selected_canvas_pan.set [ data.panel_id ]
        @data.last_canvas_pan.set data.panel_id
        

#         @el.addEventListener "click", ( ( evt ) => @selected_view = data.panel_id )
        
        return new CanvasManagerPanelInstance @el, @data, view_item, @undo_manager
        
    # De la part de Noel. Vendredi 23 septembre.
    _on_key_down: ( evt ) ->
        if @active_key.get()
            if 16 <= evt.keyCode <= 18
                return
            cur_key = ""
            cur_key += "Ctrl+"  if evt.ctrlKey
            cur_key += "Shift+" if evt.shiftKey
            cur_key += "Alt+"   if evt.altKey
            
            cur_key += String.fromCharCode( evt.keyCode ).toUpperCase()
            
            cur_key = "Del"        if evt.keyCode == 46
            cur_key = "Space"      if evt.keyCode == 32
            cur_key = "LeftArrow"  if evt.keyCode == 37
            cur_key = "UpArrow"    if evt.keyCode == 38
            cur_key = "RightArrow" if evt.keyCode == 39
            cur_key = "DownArrow"  if evt.keyCode == 40
            cur_key = "Enter"      if evt.keyCode == 13
            
            for m in @data.modules
                for a in m.actions
                    if a.key?
                        for k in a.key
                            if k == cur_key
                                a.fun? evt, this
                                break
                    
                    if a.sub? and a.sub.length > 0
                        for a in a.sub
                            if a.key?
                                for k in a.key
                                    if k == cur_key
                                        a.fun evt, this
                                        break
