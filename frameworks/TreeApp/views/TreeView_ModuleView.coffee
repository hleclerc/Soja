# 
class TreeView_ModuleView extends View
    constructor: ( @el, @roots, @selected = new Lst, @visible = new Model, @closed = new Lst, @visibility_context, @tree_app ) ->
        
        super [ @roots, @selected, @visible, @closed, @visibility_context ]
        
        @treeview = new TreeView @el, @roots, @selected, @visible, @closed, @visibility_context
#         icobar = new IcoBar @el, @tree_app

        @modules = @tree_app.data.modules
        
        @icon_container = new_dom_element
                nodeName  : "div"
                className : "FooterTreeView"
                parentNode: @el
                style:
                    position: "absolute"
                    top  : 19
                    zIndex : 100
        
        @_render_loc_actions @el, @tree_app
        
    _render_loc_actions: ( @el, @tree_app ) ->
        @el.appendChild @icon_container
    
        while @icon_container.firstChild?
            @icon_container.removeChild @icon_container.firstChild

        for m in @modules
            do ( m ) =>
                for act, j in m.actions when act.vis != false and act.loc == true
                    do ( act ) =>
                        delet = new_dom_element
                            nodeName  : "img"
                            src       : "img/trash_24.png"
                            className : "FooterTreeViewIcon"
                            parentNode: @icon_container
                            alt       : "Delete"
                            title     : "Delete"
                            onclick   : ( evt ) =>
                                act.fun evt, @tree_app
                #                 if TreeAppModule_TreeView?
                #                     console.log TreeAppModule_TreeView
                #                     TreeAppModule_TreeView.actions[ 0 ].fun evt, TreeApp

#             save = new_dom_element
#                 nodeName  : "img"
#                 src       : "img/save_24.png"
#                 className : "FooterTreeViewIcon"
#                 parentNode: footer
#                 alt       : "Save"
#                 title     : "Save"
#                 onclick   : =>
#                     for selected_tree_item_path in @selected
#                         selected_tree_item = selected_tree_item_path[ selected_tree_item_path.length - 1 ]
#                         console.log "saving : ", selected_tree_item
#                         if FileSystem?
#                             fs = FileSystem.get_inst()
#                             # we should ask for filename and path
#                             name = "my-item"
#                             fs.load "/tree_items", ( m, err ) ->
#                                 m.add_file name, new Path selected_tree_item, info.model_type "TreeItem"
                                