#
class TreeAppModule_File extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'File'
        @visible = false
                
        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.view_id and 
            app.data.focus.get() != app.treeview.view_id
            
        @actions.push
            ico: "img/orange_folder.png"
            siz: 2
            txt: "Open"
            ina: _ina
            fun: ( evt, app ) ->
                @d = new_dom_element
                    className : "browse_container"
                    id        : "id_browse_container"
                
                
                if FileSystem? and FileSystem._insts[ 0 ]?
                    fs = FileSystem._insts[ 0 ]
                else
                    fs = new FileSystem
                    FileSystem._disp = false

                    fs.load "/test_browser", ( m, err ) ->
                        if err
                            fs.load "/", ( d, err ) ->
                                m = new Directory
                                d.add_file "test_browser", m
                                t = new Directory
                                m.add_file "Result", t
                                t.add_file "Steel", ( new Directory )
                                t.add_file "Steel", ( new Lst [ 1, 2 ] )
                                m.add_file "Mesh", ( new Lst [ 1, 2 ] )
                                m.add_file "Work", ( new Lst [ 1, 2 ] )
                                
                                item_cp = new ModelEditorItem_Directory
                                    el    : @d
                                    model : m
                                    ModelEditorItem_Directory._action_list.Mesh = [
                                        ( file, path, browser ) ->
                                            console.log "open mesh"
                                            if TreeAppModule_Sketch? and app?
                                                @modules = app.data.modules
                                                for m in @modules 
                                                    if m instanceof TreeAppModule_Sketch
                                                        m.actions[ 2 ].fun evt, app, file
                                    ]
                                    ModelEditorItem_Directory._action_list.Img = [
                                        ( file, path, browser ) ->
                                            console.log "open img"
                                            if TreeAppModule_ImageSet? and app?
                                                @modules = app.data.modules
                                                for m in @modules
                                                    if m instanceof TreeAppModule_ImageSet
                                                        m.actions[ 1 ].fun evt, app, file
                                    ]
                                
                        #                     
                        else
                            new_model_editor el: @d, model: m

                

                
                    
                p = new_popup "Browse Folder", event : evt, width : 70, child: @d, onclose: =>
                    @onPopupClose( app )
                
                app.active_key.set false
                
#             key: [ "Shift+O" ]

            onPopupClose: ( app ) =>
                document.onkeydown = undefined
                app.active_key.set true