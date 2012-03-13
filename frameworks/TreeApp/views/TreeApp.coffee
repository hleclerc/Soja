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
        
    # De la part de Noel. Vendredi 23 septembre.
    _on_key_down: ( evt ) ->
        if @active_key.get()
            if 16 <= evt.keyCode <= 18
                return
            cur_key = ""
            cur_key += "Ctrl+"  if evt.ctrlKey
            cur_key += "Shift+" if evt.shiftKey
            cur_key += "Alt+"   if evt.altKey

            cur_key = "Del"        if evt.keyCode == 46
            cur_key = "Space"      if evt.keyCode == 32
            cur_key = "LeftArrow"  if evt.keyCode == 37
            cur_key = "UpArrow"    if evt.keyCode == 38
            cur_key = "RightArrow" if evt.keyCode == 39
            cur_key = "DownArrow"  if evt.keyCode == 40
            cur_key = "Enter"      if evt.keyCode == 13
            cur_key = "F5"         if evt.keyCode == 116
            # TODO prevent f5 overlapping with 't' (or f4 with 's', etc.)
#             special_keys =
#                 'esc':27,
#                 'escape':27,
#                 'tab':9,
#                 'space':32,
#                 'return':13,
#                 'enter':13,
#                 'backspace':8,
# 
#                 'scrolllock':145,
#                 'scroll_lock':145,
#                 'scroll':145,
#                 'capslock':20,
#                 'caps_lock':20,
#                 'caps':20,
#                 'numlock':144,
#                 'num_lock':144,
#                 'num':144,
# 
#                 'pause':19,
#                 'break':19,
# 
#                 'insert':45,
#                 'home':36,
#                 'delete':46,
#                 'end':35,
# 
#                 'pageup':33,
#                 'page_up':33,
#                 'pu':33,
# 
#                 'pagedown':34,
#                 'page_down':34,
#                 'pd':34,
# 
#                 'left':37,
#                 'up':38,
#                 'right':39,
#                 'down':40,
# 
#                 'f1':112,
#                 'f2':113,
#                 'f3':114,
#                 'f4':115,
#                 'f5':116,
#                 'f6':117,
#                 'f7':118,
#                 'f8':119,
#                 'f9':120,
#                 'f10':121,
#                 'f11':122,
#                 'f12':123
                
#             console.log evt.keyCode
            cur_key += String.fromCharCode( evt.keyCode ).toUpperCase()
#             cur_key += special_keys[ evt.keyCode ] || String.fromCharCode( evt.keyCode ).toLowerCase()
#             console.log cur_key
            
            for m in @data.modules
                for a in m.actions
                    if a.key? and ( not a.ina? or not a.ina( this ) )
                        for k in a.key
                            if k == cur_key
                                a.fun? evt, this
                                @cancel_natural_hotkeys evt
                                break
                    
                    if a.sub? and a.sub.length > 0
                        for a in a.sub
                            if a.key? and ( not a.ina? or not a.ina( this ) )
                                for k in a.key
                                    if k == cur_key
                                        a.fun evt, this
                                        @cancel_natural_hotkeys evt
                                        break
                                        
                    if a.menu? and a.menu.length > 0
                        for a in a.menu
                            if a.key? and ( not a.ina? or not a.ina( this ) )
                                for k in a.key
                                    if k == cur_key
                                        a.fun evt, this
                                        @cancel_natural_hotkeys evt
                                        break

    cancel_natural_hotkeys: ( evt ) ->
        if (!evt)
            evt = window.event
        evt.cancelBubble = true
        if (evt.stopPropagation)
            evt.stopPropagation()
        evt.preventDefault()

        return false