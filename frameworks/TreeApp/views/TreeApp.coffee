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
        
#         @selected_view = ""
        

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
            #res.div.addEventListener "click", ( ( evt ) => @selected_view = data.panel_id )
            @treeview = new TreeView res.div, @data.tree_items, @data.selected_tree_items, @data.visible_tree_items, @data.closed_tree_items, @data.last_canvas_pan
            res.treeview = @treeview
            res.div.onmousedown = =>
                @data.focus.set @treeview.view_id
                return true
            return res
            
        if data.panel_id == "EditView"
            res = new LayoutManagerPanelInstance @el
            res.div.className = "PanelInstanceEditView"
            #res.div.addEventListener "click", ( ( evt ) => @selected_view = data.panel_id )
            new EditView res.div, @data, @undo_manager            
            return res
    
        # else, -> canvas manager
        # add a ViewItem to display_settings
        view_item = new ViewItem @data, data.panel_id, @_next_cam
        display_settings._children.push view_item
        delete @_next_cam
        
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
        
    _on_key_down: ( evt ) ->
        if @active_key.get()
            if 16 <= evt.keyCode <= 18
                return
            cur_key = ""
            cur_key += "Ctrl+"  if evt.ctrlKey
            cur_key += "Shift+" if evt.shiftKey
            cur_key += "Alt+"   if evt.altKey
            
            special_keys = 
                8    : "BackSpace"
                9    : "Tab"
                13   : "Enter"
                19   : "Pause"
                20   : "CapsLock"
                27   : "Esc"
                32   : "Space"
                33   : "PageUp"
                34   : "PageDown"
                35   : "End"
                36   : "Home"
                37   : "LeftArrow"
                38   : "UpArrow"
                39   : "RightArrow"
                40   : "DownArrow"
                45   : "Insert"
                46   : "Del"
                112  : "F1"
                113  : "F2"
                114  : "F3"
                115  : "F4"
                116  : "F5"
                117  : "F6"
                118  : "F7"
                119  : "F8"
                120  : "F9"
                121  : "F10"
                122  : "F11"
                123  : "F12"
                144  : "NumLock"
                145  : "ScrollLock"
                
            cur_key += special_keys[ evt.keyCode ] or String.fromCharCode( evt.keyCode ).toUpperCase()

            
            
            for m in @data.modules
                for a in m.actions
                    if a.key? and ( not a.ina? or not a.ina( this ) )
                        for k in a.key
                            if k == cur_key
                                a.fun? evt, this
                                @cancel_natural_hotkeys evt
                                break
#                     
#                     if a.sub? and a.sub.act? and a.sub.act.length > 0
#                         for a in a.sub.act
#                             if a.key? and ( not a.ina? or not a.ina( this ) )
#                                 for k in a.key
#                                     if k == cur_key
#                                         a.fun? evt, this
#                                         @cancel_natural_hotkeys evt
#                                         break
                
                    while (a.sub? and a.sub.act? and a.sub.act.length > 0)
                        for ac in a.sub.act
                            if ac.key? and ( not ac.ina? or not ac.ina( this ) )
                                for k in ac.key
                                    if k == cur_key
                                        ac.fun? evt, this
                                        @cancel_natural_hotkeys evt
                                        break
                        a = ac

    
    # prevent default browser action being launch by hotkey
    cancel_natural_hotkeys: ( evt ) ->
        if (!evt)
            evt = window.event
        evt.cancelBubble = true
        if (evt.stopPropagation)
            evt.stopPropagation()
        evt.preventDefault()

        return false