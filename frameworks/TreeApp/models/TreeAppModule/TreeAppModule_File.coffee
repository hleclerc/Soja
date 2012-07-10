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
            fun: ( evt, app ) =>
                
                @content = new_dom_element
                    className : "browse_container"
                    id        : "id_browse_container"
                
                if FileSystem? and FileSystem.get_inst()?
                    fs = FileSystem.get_inst()
                else
                    fs = new FileSystem
                    FileSystem._disp = false
                
                d = "/home/monkey/sessions"
                fs.load_or_make_dir d, ( session_dir, err ) =>
                    #                     clear_page()

                    item_cp = new ModelEditorItem_Directory
                        el    : @content
                        model : session_dir
                    


                    #                     # RELOAD
                    #                     ModelEditorItem_Directory.add_action "Session", ( file, path, browser ) ->
                    #                         clear_page()
                    #                         window.location = "#" + encodeURI( "#{d}/#{file.name.get()}" )
            
                p = new_popup "Browse Session", event : evt, width : 70, child: @content, onclose: =>
                    @onPopupClose( app )
                app.active_key.set false
                
#             key: [ "Shift+O" ]


        @actions.push
            ico: "img/orange_folder.png"
            siz: 2
            txt: "Open in Tree"
            ina: _ina
            fun: ( evt, app ) =>
                @d = new_dom_element
                    className : "browse_container"
                    id        : "id_browse_container"
                
                
                if FileSystem? and FileSystem.get_inst()?
                    fs = FileSystem.get_inst()
                else
                    fs = new FileSystem
                    FileSystem._disp = false
                    
                fs.load_or_make_dir "/home/monkey/test_browser", ( d, err ) =>
                    t = new Directory
                    d.add_file "Result", t
                    d.add_file "composite01.png", ( new Img 'composite01.png' ), model_type: "Img"
                    t.add_file "Steel", ( new Directory )
                    t.add_file "Steel", ( new Lst [ 1, 2 ] )
                    d.add_file "Mesh", ( new Lst [ 1, 2 ] ), model_type: "Mesh"
                    d.add_file "Work", ( new Lst [ 1, 2 ] )
                        
                    ModelEditorItem_Directory.add_action "Mesh", ( file, path, browser ) ->
                        console.log "open mesh"
                        if TreeAppModule_Sketch? and app?
                            @modules = app.data.modules
                            for m in @modules 
                                if m instanceof TreeAppModule_Sketch
                                    m.actions[ 4 ].fun evt, app, file
                                    
                    ModelEditorItem_Directory.add_action "Img", ( file, path, browser ) ->
                        console.log "open img"                        
                        if TreeAppModule_ImageSet? and app?                            
                            # Check if file is an ImgItem, otherwise, try to build it
                            if file not instanceof ImgItem
                                console.log file
                                if file instanceof Img
                                    file = new ImgItem img, app
                                else if file instanceof File
                                    if FileSystem? and FileSystem.get_inst()?
                                        fs = FileSystem.get_inst()
                                        fs.load img, ( m, err ) ->
                                            file = file#TODO, use ptr to build real ImgItem
                                else
                                    return                                    
                                    
                            @modules = app.data.modules
                            for m in @modules
                                if m instanceof TreeAppModule_ImageSet
                                    m.actions[ 1 ].fun evt, app, file
                                    
                                    
                    ModelEditorItem_Directory.add_action "Path", ( file, path, browser ) ->
                        console.log file, path
                        if FileSystem? and FileSystem.get_inst()?
                            fs = FileSystem.get_inst()
                            fs.load path, ( m, err ) =>
                                console.log "''", m
                                #if name end like a picture (png, jpg, tiff etc)
                                file = new ImgItem "/sceen/_?u=" + m._server_id, app

                                @modules = app.data.modules
                                for m in @modules
                                    if m instanceof TreeAppModule_ImageSet
                                        m.actions[ 1 ].fun evt, app, file
                                    
                                    
                    item_cp = new ModelEditorItem_Directory
                        el    : @d
                        model : d
                        
                p = new_popup "Browse Folder", event : evt, width : 70, child: @d, onclose: =>
                    @onPopupClose( app )
                app.active_key.set false
                
#             key: [ "Shift+O" ]

    onPopupClose: ( app ) =>
        document.onkeydown = undefined
        app.active_key.set true