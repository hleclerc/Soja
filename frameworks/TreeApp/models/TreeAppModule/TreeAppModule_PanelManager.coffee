#
class TreeAppModule_PanelManager extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'Windows'


        @add_action
            ico: "img/vertical_split.png"
            siz: 1
            txt: "Vertical Split"
            fun: ( evt, app ) => @split_view evt, app, 0
            key: [ "Shift+V" ]
             
        @add_action
            ico: "img/fit.png"
            siz: 1
            txt: "Fit object to the view"
            fun: ( evt, app ) ->
                for inst in app.selected_canvas_inst()
                    inst.cm.fit()
            key: [ "F" ]
            
        @add_action
            ico: "img/horizontal_split.png"
            siz: 1
            txt: "Horizontal Split"
            fun: ( evt, app ) => @split_view evt, app, 1
            key: [ "Shift+H" ]
            
            
        cube = @add_action
            ico: "img/cube.png"
            siz: 1
            txt: "View"
            key: [ "V" ]
        
        cube.add_sub_action
            ico: "img/origin.png"
            txt: "Origin Camera"
            siz: 1
            fun: ( evt, app ) ->
                for inst in app.selected_canvas_inst()
                    inst.cm.origin()
            key: [ "O" ]
            
        cube.add_sub_action
            ico: "img/top.png"
            txt: "Watch top"
            siz: 1
            fun: ( evt, app ) ->
                for inst in app.selected_canvas_inst()
                    inst.cm.top()
            key: [ "T" ]
            
        cube.add_sub_action
            ico: "img/right.png"
            txt: "Watch right"
            siz: 1
            fun: ( evt, app ) ->
                for inst in app.selected_canvas_inst()
                    inst.cm.right()
            key: [ "R" ]
            
            
                       
        @add_action
            ico: "img/close_panel.png" 
            siz: 1
            txt: "Close current view"
            fun: ( evt, app ) ->
                d = app.data.selected_display_settings()
                for panel_id in app.data.selected_canvas_pan
                    if d._layout.rm_panel panel_id
                        app.data.visible_tree_items.rem_attr panel_id
                # new selection
                t = d._layout.panel_id_of_term_panels()
                app.data.selected_canvas_pan.clear()
                app.data.selected_canvas_pan.push t[ 0 ]
            key: [ "Shift+X" ]
        
        @add_action
            ico: "" 
            txt: "Zoom"
            fun: ( evt, app ) ->
                width_cm  = 100
                height_cm = 100
                zoom_factor = [ 1,1.1 ]
                old_cm = app.selected_canvas_inst()?[ 0 ]?.cm
                clientX = evt.clientX or old_cm.old_x
                clientY = evt.clientY or old_cm.old_y
                
                @zoom_cm_container = new_dom_element
                    parentNode: document.body
                    style     : { position: "fixed", top: clientY - height_cm * 0.5, left: clientX - width_cm * 0.5 }
                    
                zoom_cm = new CanvasManager
                    el: @zoom_cm_container
                    time : app.data.time
                    selected_items: app.data.selected_tree_items
                    theme         : app.data.selected_display_settings().theme
                    
                zoom_cm.cam.set old_cm.cam.get()
#                 x = evt.clientX - get_left( @canvas )
#                 y = evt.clientY - get_top ( @canvas )
                x = clientX
                y = clientY
                zoom_cm.cam.zoom x, y, zoom_factor, width_cm, height_cm
                
                #TODO check if new items appear
                for it, i in old_cm.items
                    zoom_cm.items.push it
                
                zoom_cm.resize 100, 100
#                 old_cm.el.addEventListener('onmousemove', @funmousemove(evt, @zoom_cm_container))
                            
            funmousemove: ( evt, zoom_cm_container ) ->
                console.log evt, zoom_cm_container
                clientX = evt.clientX
                clientY = evt.clientY
                width_cm  = 100
                height_cm = 100
                zoom_cm_container.style.left = clientX - width_cm * 0.5
                zoom_cm_container.style.top  = clientY - height_cm * 0.5
                
            key: [ "Ctrl+Alt+F" ]
                
    

    
    split_view: ( evt, app, n ) ->
        cam = undefined
        for p in app.data.selected_tree_items
            s = p[ p.length - 1 ]
            if s instanceof ShootingItem
                cam = s.cam
                
        d = app.data.selected_display_settings()
        for panel_id in app.data.selected_canvas_pan
            app._next_cam = cam
            d._layout.mk_split n, 0, panel_id, 0.5
        
        