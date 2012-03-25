#
class TreeAppModule_PanelManager extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'Windows'

        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.view_id and 
            app.data.focus.get() != app.treeview.view_id

        @actions.push
            ico: "img/vertical_split.png"
            siz: 1
            txt: "Vertical Split"
            ina: _ina
            fun: ( evt, app ) => @split_view evt, app, 0
            key: [ "Shift+V" ]
             
        @actions.push
            ico: "img/fit.png"
            siz: 1
            txt: "Fit object to the view"
            ina: _ina
            fun: ( evt, app ) ->
                for inst in app.selected_canvas_inst()
                    inst.cm.fit()
            key: [ "F" ]
            
        @actions.push
            ico: "img/horizontal_split.png"
            siz: 1
            txt: "Horizontal Split"
            ina: _ina
            fun: ( evt, app ) => @split_view evt, app, 1
            key: [ "Shift+H" ]
            
            
        cube =
            ico: "img/cube.png"
            siz: 1
            txt: "View"
            ina: _ina
            sub:
                prf: "list"
                act: [ ]
            key: [ "V" ]
        @actions.push cube
        
        cube.sub.act.push 
            ico: "img/origin.png"
            txt: "Origin Camera"
            ina: _ina
            siz: 1
            fun: ( evt, app ) ->
                for inst in app.selected_canvas_inst()
                    inst.cm.origin()
            key: [ "O" ]
            
        cube.sub.act.push 
            ico: "img/top.png"
            txt: "Watch top"
            ina: _ina
            siz: 1
            fun: ( evt, app ) ->
                for inst in app.selected_canvas_inst()
                    inst.cm.top()
            key: [ "T" ]
            
        cube.sub.act.push 
            txt: "Watch bottom"
            ina: _ina
            vis: false
            fun: ( evt, app ) ->
                for inst in app.selected_canvas_inst()
                    inst.cm.bottom()
            key: [ "B" ]
            
        cube.sub.act.push 
            ico: "img/right.png"
            txt: "Watch right"
            ina: _ina
            siz: 1
            fun: ( evt, app ) ->
                for inst in app.selected_canvas_inst()
                    inst.cm.right()
            key: [ "R" ]
            
        cube.sub.act.push 
            txt: "Watch left"
            ina: _ina
            vis: false
            siz: 1
            fun: ( evt, app ) ->
                for inst in app.selected_canvas_inst()
                    inst.cm.left()
            key: [ "L" ]
            
            
        @actions.push
            ico: "img/close_panel.png" 
            siz: 1
            txt: "Close current view"
            ina: _ina
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
        
        @actions.push
            txt: "Zoom"
            ina: _ina
            vis: false
            fun: ( evt, app ) ->
                if not @zoom_area
                    @old_cm = app.selected_canvas_inst()?[ 0 ]?.cm
                    @zoom_area = new ZoomArea @old_cm
                    @zoom_area.zoom_pos.set [ @old_cm.old_x, @old_cm.old_y ]
                    @old_cm.items.push @zoom_area
                else
                    @old_cm.items.remove_ref @zoom_area
                    delete @zoom_area
                    
            key: [ "Z" ]
                
    

    
    split_view: ( evt, app, n ) ->
        cam = undefined
        for p in app.data.selected_tree_items
            s = p[ p.length - 1 ]
            if s instanceof ShootingItem
                cam = s.cam
        console.log cam
                
        d = app.data.selected_display_settings()
        for panel_id in app.data.selected_canvas_pan
            app._next_cam = cam
            d._layout.mk_split n, 0, panel_id, 0.5
        
        