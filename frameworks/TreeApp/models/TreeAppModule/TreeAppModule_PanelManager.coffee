#
class TreeAppModule_PanelManager extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'Windows'

        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.view_id

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
                app.undo_manager.snapshot()
                app.data.rm_selected_panels()
            key: [ "Shift+X" ]
        
        @actions.push
            ico: "img/zoom_32.png"
            siz: 1
            txt: "Zoom"
            ina: _ina
#             vis: false
            fun: ( evt, app ) ->
                if not @zoom_area
                    @old_cm = app.selected_canvas_inst()?[ 0 ]?.cm
                    @theme = @old_cm.theme
                    @zoom_area = new ZoomArea @old_cm, zoom_factor : [ @theme.zoom_factor, @theme.zoom_factor, 1 ]
                    @zoom_area.zoom_pos.set [ @old_cm.mouse_x, @old_cm.mouse_y ]
                    @old_cm.items.push @zoom_area
                else
                    @old_cm.items.remove_ref @zoom_area
                    @old_cm.draw()
                    @theme.zoom_factor.set @zoom_area.zoom_factor[ 0 ] # use last zoom_factor as a default for user
                    delete @zoom_area
                    
            key: [ "Z" ]
                
        @actions.push
            txt: ""
            key: [ "UpArrow" ]
            ina: _ina
            fun: ( evt, app ) =>
                for inst in app.selected_canvas_inst()
                    inst.cm.cam.rotate -0.1, 0, 0

        @actions.push
            txt: ""
            key: [ "DownArrow" ]
            ina: _ina
            fun: ( evt, app ) =>
                for inst in app.selected_canvas_inst()
                    inst.cm.cam.rotate 0.1, 0, 0

        @actions.push
            txt: ""
            key: [ "LeftArrow" ]
            ina: _ina
            fun: ( evt, app ) =>
                for inst in app.selected_canvas_inst()
                    inst.cm.cam.rotate 0, -0.1, 0
                            
        @actions.push
            txt: ""
            key: [ "RightArrow" ]
            ina: _ina
            fun: ( evt, app ) =>
                for inst in app.selected_canvas_inst()
                    inst.cm.cam.rotate 0, 0.1, 0
    

    split_view: ( evt, app, n ) ->
        app.undo_manager.snapshot()
        cam = undefined
        child = undefined
        for p in app.data.selected_tree_items
            s = p[ p.length - 1 ]
            if s instanceof ShootingItem
                cam = s.cam
                child = s
#         console.log cam
                
        d = app.data.selected_display_settings()
        for panel_id in app.data.selected_canvas_pan
            app._next_view_item_cam = cam
            app._next_view_item_child = child
            d._layout.mk_split n, 0, panel_id, 0.5
        
        