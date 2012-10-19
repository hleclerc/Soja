# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2012 Hugo Leclerc
#
# This file is part of Soda.
#
# Soda is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Soda is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with Soda. If not, see <http://www.gnu.org/licenses/>.



#
class TreeAppModule_File extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'File'
        @visible = true
                
        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.view_id and 
            app.data.focus.get() != app.treeview.view_id
            
        @actions.push
            ico: "img/orange_folder.png"
            siz: 2
            txt: "Open"
            ina: _ina
            vis: false
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
                        el             : @content
                        model          : session_dir
                    


                    #                     # RELOAD
                    #                     ModelEditorItem_Directory.add_action "Session", ( file, path, browser ) ->
                    #                         clear_page()
                    #                         window.location = "#" + encodeURI( "#{d}/#{file.name.get()}" )
            
                p = new_popup "Browse Session", event : evt, child: @content, onclose: =>
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
                 
                if !model_id? or  model_id == -1
                  dir = "/home/monkey/test_browser"
                else
                  dir = "/home/projet_" + model_id
                fs.load_or_make_dir dir, ( d, err ) =>     
                    t = new Directory

                    d.add_file "My first directory", t
#                     d.add_file "composite01.png", ( new Img 'composite01.png' ), model_type: "Img"
#                     t.add_file "Steel", ( new Directory )
#                     t.add_file "Steel", ( new Lst [ 1, 2 ] )
#                     d.add_file "Mesh", ( new Lst [ 1, 2 ] ), model_type: "Mesh"
#                     d.add_file "Work", ( new Lst [ 1, 2 ] )

                        
                    ModelEditorItem_Directory.add_action "Mesh", ( file, path, browser ) =>
                        console.log "open mesh"
                        if TreeAppModule_Sketch? and app?
                            modules = app.data.modules
                            for m in modules
                                if m instanceof TreeAppModule_Sketch
                                    m.actions[ 4 ].fun evt, app, file
                                    
                    #                     ModelEditorItem_Directory.add_action "Img", ( file, path, browser ) ->
                    #                         if TreeAppModule_ImageSet? and app?                            
                    #                             # Check if file is an ImgItem, otherwise, try to build it
                    #                             if file not instanceof ImgItem
                    #                                 if file instanceof Img
                    #                                     file = new ImgItem img, app
                    #                                 else if file instanceof File
                    #                                     if FileSystem? and FileSystem.get_inst()?
                    #                                         fs = FileSystem.get_inst()
                    #                                         fs.load img, ( m, err ) ->
                    #                                             file = file#TODO, use ptr to build real ImgItem
                    #                                 else
                    #                                     return                                    
                    #                                     
                    #                             @modules = app.data.modules
                    #                             for m in @modules
                    #                                 if m instanceof TreeAppModule_ImageSet
                    #                                     m.actions[ 1 ].fun evt, app, file
                                    
                                    
                    ModelEditorItem_Directory.add_action "Path", ( file, path, browser ) =>
                        file.load ( m, err ) =>
                            # if file.name.get()
#                           #if name end like a picture (png, jpg, tiff etc)
                            if file.name.ends_with( ".raw" )
                                rv = @add_item_depending_selected_tree app.data, RawVolume
                                rv._children.push new FileItem file
                            else
                                img_item = new ImgItem m, app # "/sceen/_?u=" + m._server_id
                                img_item._name.set file.name
                                # @add_item_depending_selected_tree app_data, CorrelationItem
                                done = false
                                for item in app.data.get_selected_tree_items()
                                    if item.accept_child? img_item
                                        item.add_child img_item
                                        done = true
                                if not done
                                    alert "Please select in the tree an item which accepts an image"

                                #@modules = app.data.modules
                                #for m in @modules
                                #    if m instanceof TreeAppModule_ImageSet
                                #        m.actions[ 1 ].fun evt, app, img_item
                    
                    item_cp = new ModelEditorItem_Directory
                        el          : @d
                        model       : d
                        initial_path: "/home/monkey/sessions"
                        
                p = new_popup "Browse Folder", event: evt, child: @d, onclose: =>
                    @onPopupClose( app )
                app.active_key.set false
                
#             key: [ "Shift+O" ]

    onPopupClose: ( app ) =>
        document.onkeydown = undefined
        app.active_key.set true
