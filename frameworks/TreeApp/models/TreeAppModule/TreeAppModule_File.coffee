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
#                 @model = new File Directory, "LMT"
#                 
#                 p = new File ImgItem, "composite01.png"
#                 ma = new File ImgItem, "masque_0.png"
#                 d = new File Directory, "Work"
#                 m = new File Mesh, "Mesh"
#                 
#                 @model.data.children.push m
#                 @model.data.children.push ma
#                 @model.data.children.push p
#                 @model.data.children.push d
#                 
#                 
#                 mesh = new File Directory, "Mesh"
#                 pictures = new File Directory, "Pictures"
#                 result = new File Directory, "Result"
#                 d.data.children.push mesh
#                 d.data.children.push pictures
#                 d.data.children.push result
#                 
#                 
#                 pic5 = new File ImgItem, "composite05.png"
#                 pic7 = new File ImgItem, "composite07.png"
#                 pictures.data.children.push pic5
#                 pictures.data.children.push pic7
#                 
#                 mes1 = new File Mesh, "Mesh"
#                 mesh.data.children.push mes1
#                 
# 
#                 dz = new File ImgItem, "explo_dz_alpha.png"
#                 inn = new File ImgItem, "explo_in_alpha.png"
#                 re = new File ImgItem, "explo_re_alpha.png"
#                 res0 = new File ImgItem, "res_orig.png"
#                 res1 = new File ImgItem, "res_depX.png"
#                 res2 = new File ImgItem, "res_depY.png"
#                 result.data.children.push dz
#                 result.data.children.push inn
#                 result.data.children.push re
#                 result.data.children.push res0
#                 result.data.children.push res1
#                 result.data.children.push res2
#                 
#                 @d = new_dom_element
#                     className : "browse_container"
#                     id        : "id_browse_container"
#                 item_cp = new ModelEditorItem_Directory
#                     el    : @d
#                     model : @model
#                     fundblclick: ( evt, file ) =>
#                         if file.data instanceof ImgItem
#                             @modules = app.data.modules
#                             for m in @modules
#                                 if m instanceof TreeAppModule_ImageSet
#                                     m.actions[ 1 ].fun evt, app, file.data
#                                 
#                         else if file.data instanceof Mesh
#                             @modules = app.data.modules
#                             for m in @modules 
#                                 if m instanceof TreeAppModule_Sketch
#                                     m.actions[ 2 ].fun evt, app, file.data

                
                    
                p = new_popup "Browse Folder", event : evt, width : 70, child: @d, onclose: =>
                    @onPopupClose( app )
                
                app.active_key.set false
                
#             key: [ "Shift+O" ]

            onPopupClose: ( app ) =>
                document.onkeydown = undefined
                app.active_key.set true