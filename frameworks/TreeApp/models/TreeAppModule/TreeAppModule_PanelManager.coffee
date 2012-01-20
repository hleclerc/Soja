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
            ico: "img/horizontal_split.png"
            siz: 1
            txt: "Horizontal Split"
            fun: ( evt, app ) => @split_view evt, app, 1
            key: [ "Shift+H" ]
            
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
            ico: "img/fit.png"
            siz: 1
            txt: "Fit object to the view"
            fun: ( evt, app ) ->
                for inst in app.selected_canvas_inst()
                    inst.cm.fit()
            key: [ "F" ]
            
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
            

    split_view: ( evt, app, n ) ->
        d = app.data.selected_display_settings()
        for panel_id in app.data.selected_canvas_pan
            d._layout.mk_split n, 0, panel_id, 0.5
        
        